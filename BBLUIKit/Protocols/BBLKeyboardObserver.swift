//
//  BBLKeyboardObserver.swift
//  BBLUIKit
//
//  Created by Joel Perry on 7/20/16.
//  Copyright © 2018 East Five. All rights reserved.
//

import UIKit

@objc public protocol BBLKeyboardObserver: class {
    var keyboardFocusedView: UIView? { get set }
    @objc optional func keyboardWillShow(_ notification: Notification)
    @objc optional func keyboardWillHide(_ notification: Notification)
}

public extension BBLKeyboardObserver {
    
    // MARK: - Setup/Teardown
    public func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    
    public func teardownKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    public func verticalOverlap(forKeyboardInfo info: [AnyHashable : Any], view: UIView) -> CGFloat {
        guard let frameInfo = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return 0.0 }
        
        let keyboardFrame = frameInfo.cgRectValue
        let convertedFrame = view.window!.convert(keyboardFrame, to: view)
        return view.bounds.maxY - convertedFrame.minY
    }
    
    // MARK: - Adjust
    public func adjustTableView(_ tableView: UITableView, forKeyboardInfo info: [AnyHashable : Any], margin: CGFloat) {
        guard let frameInfo = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = frameInfo.cgRectValue
        
        let convertedFrame = tableView.window!.convert(keyboardFrame, to: tableView)
        let actualHeight = contentHeight(tableView)
        
        // Test keyboard visible
        if keyboardFrame.minY < UIScreen.main.bounds.height {
            let heightToAdd = tableView.bounds.maxY - convertedFrame.minY
            let newContentSize = CGSize(width: tableView.contentSize.width, height: actualHeight + heightToAdd)
            tableView.contentSize = newContentSize
        } else {
            tableView.contentSize = CGSize(width: tableView.contentSize.width, height: actualHeight)
        }
        
        if let offset = contentOffsetToClearKeyboard(keyboardFrame, scrollView: tableView, focusedView: keyboardFocusedView, margin: margin) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            if let durationKey = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber) {
                UIView.setAnimationDuration(durationKey.doubleValue)
            }
            
            tableView.setContentOffset(offset, animated: false)
            UIView.commitAnimations()
        }
    }
    
    public func adjustScrollView(_ scrollView: UIScrollView, forKeyboardInfo info: [AnyHashable : Any], margin: CGFloat) {
        guard let frameInfo = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = frameInfo.cgRectValue
        
        let convertedFrame = scrollView.window!.convert(keyboardFrame, to: scrollView)
        let actualHeight = contentHeight(scrollView)
        
        // Test keyboard visible
        if keyboardFrame.minY < UIScreen.main.bounds.height {
            let heightToAdd = scrollView.bounds.maxY - convertedFrame.minY
            let newContentSize = CGSize(width: scrollView.contentSize.width, height: actualHeight + heightToAdd)
            scrollView.contentSize = newContentSize
        } else {
            scrollView.sizeToFit()
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            if let durationKey = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber) {
                UIView.setAnimationDuration(durationKey.doubleValue)
            }
            
            scrollView.setContentOffset(CGPoint.zero, animated: false)
            UIView.commitAnimations()
        }
        
        if let offset = contentOffsetToClearKeyboard(keyboardFrame, scrollView: scrollView, focusedView: keyboardFocusedView, margin: margin) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            if let durationKey = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber) {
                UIView.setAnimationDuration(durationKey.doubleValue)
            }
            
            scrollView.setContentOffset(offset, animated: false)
            UIView.commitAnimations()
        }
    }
    
    // MARK: - Private
    private func contentOffsetToClearKeyboard(_ keyboardFrame: CGRect, scrollView: UIScrollView, focusedView: UIView?, margin: CGFloat) -> CGPoint? {
        guard let focused = focusedView else { return nil }
        
        let convertedFrame = scrollView.window!.convert(keyboardFrame, to: scrollView)
        
        var viewFrame = scrollView.convert(focused.frame, from: focused.superview)
        viewFrame.size.height += margin
        
        if convertedFrame.intersects(viewFrame) {
            let newYOffset = scrollView.contentOffset.y + (viewFrame.maxY - convertedFrame.minY)
            return CGPoint(x: 0.0, y: newYOffset)
        }
        return nil
    }
    
    private func contentHeight(_ tableView: UITableView) -> CGFloat {
        let index = tableView.numberOfSections - 1
        return tableView.rect(forSection: index).maxY
    }
    
    private func contentHeight(_ scrollView: UIScrollView) -> CGFloat {
        return scrollView.subviews.reduce(0.0) { (height, view) -> CGFloat in
            return (view.frame.maxY > height) ? view.frame.maxY : height
        }
    }
}
