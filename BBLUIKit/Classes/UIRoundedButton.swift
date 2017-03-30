//
//  UIRoundedButton.swift
//  OrderOwl
//
//  Created by Joel Perry on 6/18/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

<<<<<<< HEAD
public class UIRoundedButton: UIButton {
    @IBInspectable public var cornerRadius: CGFloat = 5 {
=======
open class UIRoundedButton: UIButton {
    @IBInspectable open var cornerRadius: CGFloat = 5 {
>>>>>>> Swift_3.0
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
<<<<<<< HEAD
    override public var enabled: Bool {
=======
    override open var isEnabled: Bool {
>>>>>>> Swift_3.0
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
