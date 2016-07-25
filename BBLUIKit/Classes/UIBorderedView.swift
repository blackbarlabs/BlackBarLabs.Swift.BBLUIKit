//
//  UIBorderedView.swift
//  OrderOwl
//
//  Created by Joel Perry on 5/26/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

public class UIBorderedView: UIView {
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.CGColor }
    }
}

