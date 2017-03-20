import UIKit
import PlaygroundSupport
/*:
 # Draw My Tune
 #### Created by **Patrick Murray** for a WWDC17 Scholarship Application
 'Draw My Tune' is an awesome (but also somewhat awkward) little experiment in combining a drawing tool with a music sampler. It allows you to *"play"* your 2D line drawings.
 

 > To run *Draw My Tune* please make usre the Timeline view is visible in the assistant editor and make sure the device volume is above zero (but also not too loud, because I bet some of your drawings will sound terrible—no offense 🙃.)
 
 ------

 
 
*/
let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 490, height: 490))
PlaygroundPage.current.liveView = mainView
PlaygroundPage.current.needsIndefiniteExecution = true

let musicView = MusicView(autoPlay: true)
mainView.addSubview(musicView)


//
//if let player = SoundPlayer() {
//
//    player.changePressureTo(127)
//    player.start(note: 60,velocity: 127)
//    sleep(1)
//    sleep(1)
//    player.stop(note: 60)
//
//    
//}
//    


