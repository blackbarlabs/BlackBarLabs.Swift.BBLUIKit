//
//  UIBorderedView.swift
//  OrderOwl
//
//  Created by Joel Perry on 5/26/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

<<<<<<< HEAD
public class UIBorderedView: UIView {
    @IBInspectable public var cornerRadius: CGFloat = 0 {
=======
open class UIBorderedView: UIView {
    @IBInspectable open var cornerRadius: CGFloat = 0 {
>>>>>>> Swift_3.0
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
<<<<<<< HEAD
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.CGColor }
=======
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.cgColor }
>>>>>>> Swift_3.0
    }
}

