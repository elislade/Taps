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
        
        // Initalize and pre-buffer AVAudioPlayers
        for note in notes {
            let path = NSBundle.mainBundle().pathForResource(note, ofType: "caf")
            
            if let safePath = path {
                do {
                    let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: safePath))
                    
                    player.prepareToPlay()
                    players.append(player)
                    
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
            
            radiateCircle(fromPoint: point, inView: self.view)
            playNote(fromPoint: point, inView: self.view)
        }
    }
    
    
    func makeCirclePath(fromCenter point: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let rect = CGRect(x: point.x - radius, y: point.y - radius, width: 2 * radius, height: 2 * radius)
        return UIBezierPath(roundedRect: rect, cornerRadius: radius)
    }
    
    
    func radiateCircle(fromPoint point:CGPoint, inView view: UIView) {
        
        let layer = CAShapeLayer()
        layer.fillColor = colors[colorIndex].CGColor
        view.layer.addSublayer(layer)
        
        colorIndex = colorIndex == (colors.count - 1) ? 0 : colorIndex + 1
        
        let radius:CGFloat = 50.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        
        //Size Animation
        let sizeAnim = CABasicAnimation(keyPath: "path")
        sizeAnim.fromValue = makeCirclePath(fromCenter: point, withRadius: radius).CGPath
        sizeAnim.toValue = makeCirclePath(fromCenter: point, withRadius: 3 * radius).CGPath
        
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
    
    
    func playNote(fromPoint point:CGPoint, inView view: UIView){

        let step = view.frame.width / CGFloat(players.count)
        let index = Int(floor( point.x / step))
        
        if index >= 0 && index < players.count {
            players[index].currentTime = 0.0
            players[index].play()
        }
    }

}

