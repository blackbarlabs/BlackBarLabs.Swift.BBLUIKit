//
//  UIBorderedView.swift
//  OrderOwl
//
//  Created by Joel Perry on 5/26/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

class UIBorderedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.CGColor }
    }
}

