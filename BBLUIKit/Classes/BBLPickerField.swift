//
//  BBLPickerField.swift
//  BBLUIKit
//
//  Created by Joel Perry on 11/3/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import UIKit

open class BBLPickerField: UITextField {
    public var pickerData: () -> [String]
    public var endEditing: (String?) -> Void
    public var toolbarTintColor: UIColor = .black
    
    private lazy var picker: UIPickerView = {
        let p = UIPickerView()
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: p.frame.width, height: 44.0))
        toolbar.barStyle = .default
        toolbar.tintColor = toolbarTintColor
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.items = [ cancel, space, done ]
        
        p.dataSource = self
        p.delegate = self
        self.inputAccessoryView = toolbar
        return p
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        endEditing = { _ in }
        pickerData = { return [String]() }
        super.init(coder: aDecoder)
        delegate = self
    }
    
    @objc private func cancelPressed() {
        resignFirstResponder()
    }
    
    @objc private func donePressed() {
        resignFirstResponder()
        let selected = picker.selectedRow(inComponent: 0)
        if selected >= 0 && selected < pickerData().count {
            text = pickerData()[selected]
            endEditing(text)
        }
    }
}

extension BBLPickerField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        inputView = picker
        if let t = text, let selected = pickerData().index(of: t) {
            picker.selectRow(selected, inComponent: 0, animated: true)
        } else {
            if !pickerData().isEmpty {
                picker.selectRow(0, inComponent: 0, animated: true)
            }
        }
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        textField.text = nil
        endEditing(nil)
        return false
    }
}

extension BBLPickerField: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData().count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row >= pickerData().count { return nil }
        return pickerData()[row]
    }
}

