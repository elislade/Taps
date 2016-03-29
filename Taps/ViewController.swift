//
//  ViewController.swift
//  Taps
//
//  Created by Eli Slade on 2016-03-27.
//  Copyright © 2016 Eli Slade. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var colorIndex = 0
    
    let colors = [
        UIColor(red:1.00, green:0.19, blue:0.38, alpha:1.00),
        UIColor(red:1.00, green:0.58, blue:0.27, alpha:1.00),
        UIColor(red:1.00, green:0.84, blue:0.28, alpha:1.00),
        UIColor(red:0.48, green:1.00, blue:0.53, alpha:1.00),
        UIColor(red:0.26, green:0.91, blue:1.00, alpha:1.00),
        UIColor(red:0.28, green:0.38, blue:1.00, alpha:1.00),
        UIColor(red:0.73, green:0.28, blue:1.00, alpha:1.00),
        UIColor(red:1.00, green:0.28, blue:0.75, alpha:1.00)
    ]
    
    let notes = ["(30)WD3", "(31)BD3#", "(32)WE3", "(33)WF3", "(34)BF3#", "(35)WG3", "(36)BG3#", "(37)WA3"]
    var players:[AVAudioPlayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initalize and pre-buffer AVAudioPlayers
        for note in notes {
            let player:AVAudioPlayer?
            let path = NSBundle.mainBundle().pathForResource(note, ofType: "caf")
            
            if let safePath = path {
            
                do {
                    player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: safePath))
                    
                    if let safePlayer = player {
                        safePlayer.prepareToPlay()
                        players.append(safePlayer)
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let point = touch.locationInView(self.view)
            
            radiateCircle(fromPoint: point)
            playNote(fromPoint: point)
        }
    }
    
    
    func radiateCircle(fromPoint point:CGPoint) {
        
        let layer = CAShapeLayer()
        layer.fillColor = colors[colorIndex].CGColor
        self.view.layer.addSublayer(layer)
        
        colorIndex = colorIndex == (colors.count - 1) ? 0 : colorIndex + 1
        
        let radius:CGFloat = 50.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        
        //Size Animation
        let sizeAnim = CABasicAnimation(keyPath: "path")
        sizeAnim.fromValue = UIBezierPath(roundedRect: CGRect(x: point.x - radius, y: point.y - radius, width: 2.0 * radius, height: 2.0 * radius) , cornerRadius: radius).CGPath
        sizeAnim.toValue = UIBezierPath(roundedRect: CGRect(x: point.x - (radius * 3), y: point.y - (radius * 3), width: 6.0 * radius, height: 6.0 * radius) , cornerRadius: radius * 3).CGPath
        
        //Opacity Animation
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0.9
        opacityAnim.toValue = 0.0

        //Animation Group
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [sizeAnim, opacityAnim]
        animationGroup.duration = 1.0
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        layer.addAnimation(animationGroup, forKey: nil)
        CATransaction.commit()
    }
    
    func playNote(fromPoint point:CGPoint){

        let step = self.view.frame.width / CGFloat(players.count)
        let index = Int(floor( point.x / step))
        print(index)
        
        players[index].stop()
        players[index].currentTime = 0.0
        players[index].play()
    }

}

