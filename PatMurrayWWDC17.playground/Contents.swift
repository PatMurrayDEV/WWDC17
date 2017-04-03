import UIKit
import PlaygroundSupport
/*:
 # Draw My Tune
 #### Created by **Patrick Murray** for a WWDC17 Scholarship Application
 'Draw My Tune' is an awesome (but also somewhat awkward) little experiment in combining a drawing tool with a music sampler. It allows you to *"play"* your 2D line drawings.
 
 This was inspired by this: https://www.youtube.com/watch?v=lVybwjl_GI0
 
 
 > To run *Draw My Tune* please make sure the Timeline view is visible in the assistant editor and make sure the device volume is above zero (but also not too loud, because I bet some of your drawings will sound terrible—no offence 🙃.)
 
 ------
 
 
 */
let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 490, height: 490))
PlaygroundPage.current.liveView = mainView
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 Set the duration of playback. Should be greater than 10 seconds. **If you want your *masterpiece* to play longer, why not try extending it?**
*/
let duration = 10

/*: 
 
 `GuidesAlpha` is how much you want to see the pixel to note mapping that is occuring behind the scenes. I think it's fun to try it off first, then to turn it up once your art gets more advanced.
 */
let guidesAlpha : CGFloat = 0.0


let musicView = MusicView(duration: duration, guidesAlpha: guidesAlpha)
mainView.addSubview(musicView)

/*:
 ### Image Preload
 Un-comment out whichever image you wish to preload with
 
 */
musicView.insetDrawing(image: #imageLiteral(resourceName: "help.png")) // Help
//musicView.insetDrawing(image: #imageLiteral(resourceName: "bridge.png")) // Sydney Harbour Bidge
//musicView.insetDrawing(image: #imageLiteral(resourceName: "trex.png")) // T-Rex (this sounds half decent)







