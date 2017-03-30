//
//  UIRoundedButton.swift
//  BBLUIKit
//
//  Created by Joel Perry on 6/18/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

open class UIRoundedButton: UIButton {
    @IBInspectable open var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
