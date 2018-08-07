//
//  BBLPopoverTableViewController.swift
//  BBLUIKit
//
//  Created by Joel Perry on 5/12/18.
//  Copyright © 2018 Joel Perry. All rights reserved.
//

import UIKit

open class BBLPopoverTableViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet public weak var navItem: UINavigationItem!
    @IBOutlet public weak var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet public weak var navBar: UINavigationBar!
    
    open var extraPadding: CGFloat { return 0.0 }
    
    // MARK: - Initialization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        if UIDevice.current.userInterfaceIdiom == .pad {
            modalPresentationStyle = .popover
            popoverPresentationController?.delegate = self
            popoverPresentationController?.backgroundColor = .white
//        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 300.0, height: verticalPadding)
        addObserver(self, forKeyPath: "tableView.contentSize", options: [ .old, .new ], context: &kvoContext)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        removeObserver(self, forKeyPath: "tableView.contentSize")
        print("deinit " + String(describing: self))
    }
    
    // MARK: - KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kvoContext && keyPath == "tableView.contentSize" { updateSize() }
    }
    
    // MARK: - Actions
    @IBAction open func dismissAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Private
    private var kvoContext = 0
    
    private func updateSize() {
        var tableHeight: CGFloat = 0.0
        if tableView.numberOfSections > 0 {
            tableHeight = tableView.rect(forSection: tableView.numberOfSections - 1).maxY
        }
        var size = preferredContentSize
        size.height = min(tableHeight + verticalPadding , 600.0)
        preferredContentSize = size
    }
    
    private var verticalPadding: CGFloat {
        return navBarHeightConstraint.constant + 24.0 + extraPadding
    }
}

extension BBLPopoverTableViewController: UIPopoverPresentationControllerDelegate {
    open func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        navItem.leftBarButtonItems = nil
        navItem.rightBarButtonItems = nil
        navBarHeightConstraint.constant = 0.0
        navBar.isHidden = true
    }
    
    open func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


