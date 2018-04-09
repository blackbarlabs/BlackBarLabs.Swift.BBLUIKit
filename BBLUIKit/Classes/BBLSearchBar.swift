//
//  BBLSearchBar.swift
//  BBLUIKit
//
//  Created by Joel Perry on 4/9/18.
//  Copyright © 2018 Joel Perry. All rights reserved.
//

import UIKit

open class BBLSearchBar: UISearchBar {
    public var endEditing: ((String?) -> Void)?
    public var validateInput: ((String) -> Bool)?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
}

extension BBLSearchBar: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return validateInput?(text) ?? true
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        resignFirstResponder()
        endEditing?(searchBar.text)
        return true
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        endEditing?(searchBar.text)
    }
}
