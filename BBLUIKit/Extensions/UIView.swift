//
//  UIView.swift
//  BBLUIKit
//
//  Created by Joel Perry on 7/19/16.
//  Copyright © 2018 East Five. All rights reserved.
//

import UIKit

public extension UIView {
    public func rotate180Degrees(_ duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi
        rotateAnimation.duration = duration
        
        if let delegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
