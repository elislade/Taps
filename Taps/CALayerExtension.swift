//
//  CALayerExtension.swift
//  Taps
//
//  Created by Eli Slade on 2018-06-15.
//  Copyright © 2018 Eli Slade. All rights reserved.
//

import UIKit

extension CALayer {
    func transact(duration:TimeInterval, animations: [CAAnimation], completion: @escaping ()->Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = animations
        animationGroup.duration = duration
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.add(animationGroup, forKey: nil)
        CATransaction.commit()
    }
}
