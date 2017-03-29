import UIKit


class DrawView : UIView {
    
    
    // Set up variables
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    public var duration = TimeInterval(10)
    var playing = false
    
    // Main is for the drawing, and temp is for the current line
    let mainImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 490, height: 490))
    let tempImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 490, height: 490))
    
    //Line
    let redLine = UIView(frame: CGRect(x: -5, y: 0, width: 5, height: 490))
    
    // Buttons
    public var playButton : UIButton = UIButton(type: .roundedRect)
    public var stopButton : UIButton = UIButton(type: .roundedRect)
    
    
    // Basic init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        
        redLine.backgroundColor = .red
        
        
        self.addSubview(tempImageView)
        self.addSubview(mainImageView)
        self.addSubview(redLine)
    }
    
    // Not implemented
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Drawing code
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        if playing {
            return
        }
        
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    
    // Catch the start of a touch and save some variables
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    // Catch a drag (or move)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    // Catch the end of a touch
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Combine temp into main image view
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: .normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //clear the temp
        tempImageView.image = nil
    }
    
    // Resets the drawing view
    public func resetDrawing() {
        mainImageView.image = nil
    }
    
    
    
    public func printImage() {
        let array = mainImageView.image?.pixelData()
        if let player = SoundPlayer() {
            
            playButton.isUserInteractionEnabled = false
            stopButton.isUserInteractionEnabled = false
            playButton.alpha = 0.1
            stopButton.alpha = 0.1
            playing = true
            
            
            // Reset the red line just in case
            redLine.frame = CGRect(x: 0 - self.redLine.frame.width, y: 0, width: self.redLine.frame.width, height: self.frame.height)
            
            //Animate the red line
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                self.redLine.frame = CGRect(x: self.frame.width, y: 0, width: self.redLine.frame.width, height: self.frame.height)
            }, completion: { (success) in
                 self.redLine.frame = CGRect(x: 0 - self.redLine.frame.width, y: 0, width: self.redLine.frame.width, height: self.frame.height)
            })

            // Play the music
            player.playArrays(array!, time: duration , completion: { success in
                if success {
                    self.playButton.isUserInteractionEnabled = true
                    self.stopButton.isUserInteractionEnabled = true
                    self.playing = false
                    self.playButton.alpha = 1.0
                    self.stopButton.alpha = 1.0
                }
            })
        }
    }
    
    
    public func insertImage(image: UIImage) {
        mainImageView.image = image
    }
    
    
    
    
}

