
// Import all the things!
import Foundation
import AVFoundation




public class SoundPlayer {
    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    let sampler = AVAudioUnitSampler()
    
    let fontPath = Bundle.main.path(forResource: "FreeFont", ofType: "sf2")
    
    public init?() {
        
        let font = NSURL.fileURL(withPath: fontPath!)
        
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: engine.mainMixerNode.outputFormat(forBus: 0))
        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: nil)
        do {
            try engine.start()
        } catch let e {
            print(e)
            return nil
        }
        do {
            try sampler.loadSoundBankInstrument(at: font, program: 0, bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB), bankLSB: UInt8(kAUSampler_DefaultBankLSB))
        } catch let e {
            print(e)
            return nil
        }
    }
    public func start(note: UInt8, velocity: UInt8 = 64) {
        sampler.startNote(note, withVelocity: velocity, onChannel: 0)
    }
    public func stop(note: UInt8) {
        sampler.stopNote(note, onChannel: 0)
    }
    public func changePressureTo(_ pressure: UInt8) {
        sampler.sendPressure(pressure, onChannel: 0)
    }
    public func changePitchTo(_ pitch: UInt16) {
        sampler.sendPitchBend(pitch, onChannel: 0)
    }
    public func stopAll() {
        for key in 1...127 {
            self.stop(note: UInt8(key))
        }
    }
    
    
    let keys = [
    
        // In the Key of C Major
        // Thus no black notes
        4	:	40	,	// E
        8	:	41	,	// F
        12	:	43	,	// G
        16	:	45	,	// A
        20	:	47	,	// B
        24	:	48	,	// C
        28	:	50	,	// D
        32	:	52	,	// E
        36	:	53	,	// F
        40	:	55	,	// G
        44	:	57	,	// A
        48	:	59	,	// B
        52	:	60	,	// Middle C
        56	:	62	,	// D
        60	:	64	,	// E
        64	:	65	,	// F
        68	:	67	,	// G
        72	:	69	,	// A
        76	:	71	,	// B
        80	:	72	,	// C
        84	:	74	,	// D
        88	:	76	,	// E
        92	:	77	,	// F
        96	:	79	,	// G
        100	:	81	,	// A
    
    ]
    
    // Arrays to hold notes
    var nowplaying = [UInt8]()
    
    func roundTo(x : Double) -> Int {
        return Int(ceil(Double(4 * Int(round(x / 4.0)))))
    }
    
    
    public func playRow(_ row: [UInt8]) {
        var upnext = [UInt8]()
        let rowCount = Double(row.count/2)
        for (index, note) in row.enumerated() {
            if note > 1 {
                let per = (Double(index) / rowCount) * 100.0
                let perRounded = self.roundTo(x: per)
                if let key = keys[100-perRounded] {
                    upnext.append(UInt8(key))
                }
            }
        }
        
        playNotes(next: upnext)
    }
    
    
    // Play notes
    public func playNotes(next: [UInt8]) {
        
        let nextUnique = Array(Set(next))
        
        // Notes to be added
        var addNotes = [UInt8]()
        
        // Notes to be sustained
        var sustainedNotes = [UInt8]()
        
        // Notes that need to play next
        for note in nextUnique {
            if !nowplaying.contains(note) {
                addNotes.append(note)
            } else {
                sustainedNotes.append(note)
            }
        }
        
        //Fail Safe
        if addNotes.count + sustainedNotes.count > 20 {
            sustainedNotes.removeAll()
        }
        
        // Notes that need to be stopped
        let removeNotes = Array(Set(nowplaying).subtracting(sustainedNotes))
        for note in removeNotes {
            self.stop(note: note)
        }

        
        // Notes that need to be added
        for note in addNotes {
            self.start(note: note)
        }
                
        sustainedNotes.append(contentsOf: addNotes)
        self.nowplaying = sustainedNotes
        
    }

    // Timer vars
    var timer = Timer()
    var counter  = 0
    
    // Play all the arrays taking a time and returning a completion handler
    public func playArrays(_ array: [[UInt8]], time : Double = 20.0,completion: @escaping (_ : Bool) -> Void) {
        
        counter = 0
        let interval = time/50.0
        timer = Timer.init(timeInterval: interval, repeats: true, block: { (timer) in
            
            if self.counter < array.count {
                self.playRow(array[self.counter])
                
                self.counter = self.counter + 1
                completion(false)
            } else {
                timer.invalidate()
                completion(true)
            }
            
        })
        
        RunLoop.current.add(timer, forMode: .commonModes)
        
    }
    
}


