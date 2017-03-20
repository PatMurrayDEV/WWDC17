import UIKit



public class MusicView : UIView {

    // Define some usefull colours
    let greenColor = UIColor(hue:0.25, saturation:0.89, brightness:0.89, alpha:1.00)
    let blueColor = UIColor(hue:0.59, saturation:0.67, brightness:0.89, alpha:1.00)
    let orangeColor = UIColor(hue:0.10, saturation:0.86, brightness:0.96, alpha:1.00)

    // Create the Midi Player / Sampler
    let player = SoundPlayer()
    
    // Drawing ivars
    let drawingView = DrawView(frame: CGRect(x: 0, y: 0, width: 490, height: 490))
    var lastPoint = CGPoint.zero
    var swiped = false
    
    
    // Init this view!
    public init(autoPlay: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 490, height: 490))
        self.addSubview(drawingView)
        drawingView.backgroundColor = blueColor
        createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public func createUI()  {
        self.backgroundColor = .white
        
        let playButton = createButton(color: greenColor, x: 36, y: 36, title: "▶", target: #selector(buttonClicked))
        self.addSubview(playButton)

        let clearButton = createButton(color: orangeColor, x: 96, y: 36, title: "✖", target: #selector(resetButtonTapped))
        self.addSubview(clearButton)
        
    }
    
    
    func createButton(color: UIColor, x: Int, y: Int, title: String = "", target: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: x, y: y, width: 50, height: 50)
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.addTarget(self, action:target, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    
    public func buttonClicked(sender: UIButton!) {
        print("Button Clicked \(sender))")
//        player?.start(note: 100)
    }
    
    func resetButtonTapped(sender: UIButton!) {
        drawingView.resetDrawing()
    }
    
    



}
