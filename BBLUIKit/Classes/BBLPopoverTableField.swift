//
//  BBLPopoverTableField.swift
//  BBLUIKit
//
//  Created by Joel Perry on 12/17/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import UIKit

open class BBLPopoverTableField: UITextField {
    public var endEditing: (String?) -> Void
    public var parentViewController: UIViewController?
    public var popoverSize = CGSize(width: 0.0, height: 0.0)
    public var tableData: () -> [String]
    
    private var tableViewController: UITableViewController {
        let t = UITableViewController(style: .plain)
        t.modalPresentationStyle = .popover
        t.preferredContentSize = CGSize(width: self.popoverSize.width, height: 1.0)
        
        t.tableView.dataSource = self
        t.tableView.delegate = self
        
        t.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PopTableCell")
        t.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        t.tableView.showsVerticalScrollIndicator = true
        
        return t
    }
    
    required public init?(coder aDecoder: NSCoder) {
        endEditing = { _ in }
        tableData = { return [String]() }
        super.init(coder: aDecoder)
        delegate = self
    }
}

extension BBLPopoverTableField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tvc = tableViewController
        
        let pop = tvc.popoverPresentationController
        pop?.sourceView = self
        pop?.sourceRect = self.bounds
        pop?.permittedArrowDirections = .up
        
        parentViewController?.present(tvc, animated: true) {
            var size = tvc.preferredContentSize
            size.height = min(self.popoverSize.height, tvc.tableView.contentSize.height)
            tvc.preferredContentSize = size
        }
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        endEditing(nil)
        parentViewController?.dismiss(animated: true)
        resignFirstResponder()
        return true
    }
}

extension BBLPopoverTableField: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopTableCell", for: indexPath)
        cell.textLabel?.text = tableData()[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        text = tableData()[indexPath.row]
        endEditing(tableData()[indexPath.row])
        parentViewController?.dismiss(animated: true)
        resignFirstResponder()
    }
}

