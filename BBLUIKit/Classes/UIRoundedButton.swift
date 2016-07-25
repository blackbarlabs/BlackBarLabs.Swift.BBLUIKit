//
//  UIRoundedButton.swift
//  OrderOwl
//
//  Created by Joel Perry on 6/18/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

class UIRoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override var enabled: Bool {
        didSet {
            self.alpha = enabled ? 1.0 : 0.5
        }
    }
}
