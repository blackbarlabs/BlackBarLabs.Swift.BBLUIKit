//
//  UIBorderedView.swift
//  BBLUIKit
//
//  Created by Joel Perry on 5/26/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

open class UIBorderedView: UIView {
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.cgColor }
    }
}

