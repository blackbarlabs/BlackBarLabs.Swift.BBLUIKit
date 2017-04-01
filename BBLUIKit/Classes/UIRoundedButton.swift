//
//  UIRoundedButton.swift
//  BBLUIKit
//
//  Created by Joel Perry on 6/18/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

open class UIRoundedButton: UIButton {
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
