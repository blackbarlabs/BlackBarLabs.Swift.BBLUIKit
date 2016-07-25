//
//  UIView.swift
//  OrderOwl
//
//  Created by Joel Perry on 7/19/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

extension UIView {
    func rotate180Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI)
        rotateAnimation.duration = duration
        
        if let delegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}
