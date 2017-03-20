
// Import all the things!
import Foundation
import AVFoundation




public struct SoundPlayer {
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
        }
        catch let e {
            print(e)
            return nil
        }
        do {
            try sampler.loadSoundBankInstrument(at: font, program: 0, bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB), bankLSB: 0)
        }
        catch let e {
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
    
}
