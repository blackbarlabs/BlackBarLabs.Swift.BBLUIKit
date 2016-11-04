//
//  BBLTextField.swift
//  BBLUIKit
//
//  Created by Joel Perry on 11/3/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import UIKit

open class BBLTextField: UITextField {
    public var endEditing: (String?) -> Void
    
    required public init?(coder aDecoder: NSCoder) {
        endEditing = { _ in }
        super.init(coder: aDecoder)
        delegate = self
    }
}

extension BBLTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        endEditing(text)
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        endEditing(nil)
        return true
    }
}
