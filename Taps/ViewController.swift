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

    var players:[AVAudioPlayer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        players = loadAudio(["(30)WD3", "(31)BD3#", "(32)WE3", "(33)WF3", "(34)BF3#", "(35)WG3", "(36)BG3#", "(37)WA3"])
    }

    func loadAudio(_ strings: [String]) -> [AVAudioPlayer] {
        var players = [AVAudioPlayer]()
        for string in strings {
            if let path = Bundle.main.path(forResource: string, ofType: "caf") {
                do {
                    let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    
                    player.prepareToPlay()
                    players.append(player)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        return players
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self.view)
            radiateCircle(from: point, in: self.view)
            playNote(from: point, in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self.view)
            radiateCircle(from: point, in: self.view)
        }
    }
    
    func makeCircle(at point:CGPoint, with size:CGFloat) -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: point.x - (size/2), y: point.y - (size/2), width: size, height: size)
        layer.cornerRadius = size / 2
        colorIndex = colorIndex == (colors.count - 1) ? 0 : colorIndex + 1
        layer.backgroundColor = colors[colorIndex].cgColor
        return layer
    }
    
    func radiateCircle(from point:CGPoint, in view: UIView) {
        let circle = makeCircle(at: point, with: 100.0)
        circle.opacity = 0
        view.layer.addSublayer(circle)
        
        let sizeAnim = CABasicAnimation(keyPath: "transform.scale")
        sizeAnim.fromValue = 1
        sizeAnim.toValue = 2
        
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0.9
        opacityAnim.toValue = 0.0
        
        circle.transact(
            duration:0.7,
            animations: [opacityAnim, sizeAnim],
            completion: { circle.removeFromSuperlayer() }
        )
    }
    
    func playNote(from point:CGPoint, in view: UIView){

        let step = view.frame.width / CGFloat(players.count)
        let index = Int(floor( point.x / step))
        
        if index >= 0 && index < players.count {
            players[index].currentTime = 0.0
            players[index].play()
        }
    }
}
