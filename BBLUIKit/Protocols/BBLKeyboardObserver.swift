//
//  BBLKeyboardObserver.swift
//  OrderOwl
//
//  Created by Joel Perry on 7/20/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

@objc protocol BBLKeyboardObserver: class {
    @objc func keyboardFrameWillChange(_ notification: Notification)
    var keyboardFocusedView: UIView? { get set }
}

extension BBLKeyboardObserver {
    
    // MARK: - Setup/Teardown
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func teardownKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    // MARK: - Adjust
    func adjustTableView(_ tableView: UITableView, forKeyboardInfo info: [NSObject : AnyObject], margin: CGFloat) {
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]?.cgRectValue else { return }
        
        let convertedFrame = tableView.window!.convert(keyboardFrame, to: tableView)
        let actualHeight = contentHeight(tableView)
        
        // Test keyboard visible
        if keyboardFrame.minY < UIScreen.main().bounds.height {
            let heightToAdd = tableView.bounds.maxY - convertedFrame.minY
            let newContentSize = CGSize(width: tableView.contentSize.width, height: actualHeight + heightToAdd)
            tableView.contentSize = newContentSize
        } else {
            tableView.contentSize = CGSize(width: tableView.contentSize.width, height: actualHeight)
        }
        
        if let offset = contentOffsetToClearKeyboard(keyboardFrame, scrollView: tableView, focusedView: keyboardFocusedView, margin: margin) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                UIView.setAnimationDuration(duration)
            }
            
            tableView.setContentOffset(offset, animated: false)
            UIView.commitAnimations()
        }
    }
    
    func adjustScrollView(_ scrollView: UIScrollView, forKeyboardInfo info: [NSObject : AnyObject], margin: CGFloat) {
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]?.cgRectValue else { return }
        
        let convertedFrame = scrollView.window!.convert(keyboardFrame, to: scrollView)
        let actualHeight = contentHeight(scrollView)
        
        // Test keyboard visible
        if keyboardFrame.minY < UIScreen.main().bounds.height {
            let heightToAdd = scrollView.bounds.maxY - convertedFrame.minY
            let newContentSize = CGSize(width: scrollView.contentSize.width, height: actualHeight + heightToAdd)
            scrollView.contentSize = newContentSize
        } else {
            scrollView.sizeToFit()
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                UIView.setAnimationDuration(duration)
            }
            
            scrollView.setContentOffset(CGPoint.zero, animated: false)
            UIView.commitAnimations()
            
        }
        
        if let offset = contentOffsetToClearKeyboard(keyboardFrame, scrollView: scrollView, focusedView: keyboardFocusedView, margin: margin) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                UIView.setAnimationDuration(duration)
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
        return tableView.rowHeight * CGFloat(tableView.numberOfRows(inSection: 0))
    }
    
    private func contentHeight(_ scrollView: UIScrollView) -> CGFloat {
        return scrollView.subviews.reduce(0.0) { (height, view) -> CGFloat in
            return (view.frame.maxY > height) ? view.frame.maxY : height
        }
    }
}
