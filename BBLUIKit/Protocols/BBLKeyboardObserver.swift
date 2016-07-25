//
//  BBLKeyboardObserver.swift
//  OrderOwl
//
//  Created by Joel Perry on 7/20/16.
//  Copyright © 2016 East Five. All rights reserved.
//

import UIKit

@objc protocol BBLKeyboardObserver: class {
    @objc func keyboardFrameWillChange(notification: NSNotification)
    var keyboardFocusedView: UIView? { get set }
}

extension BBLKeyboardObserver {
    
    // MARK: - Setup/Teardown
    func setupKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardFrameWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func teardownKeyboardObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Adjust
    func adjustTableView(tableView: UITableView, forKeyboardInfo info: [NSObject : AnyObject], margin: CGFloat) {
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() else { return }
        
        let convertedFrame = tableView.window!.convertRect(keyboardFrame, toView: tableView)
        let actualHeight = contentHeight(tableView)
        
        // Test keyboard visible
        if keyboardFrame.minY < UIScreen.mainScreen().bounds.height {
            let heightToAdd = tableView.bounds.maxY - convertedFrame.minY
            let newContentSize = CGSize(width: tableView.contentSize.width, height: actualHeight + heightToAdd)
            tableView.contentSize = newContentSize
        } else {
            tableView.contentSize = CGSize(width: tableView.contentSize.width, height: actualHeight)
        }
        
        if let offset = contentOffsetToClearKeyboard(keyboardFrame, scrollView: tableView, focusedView: keyboardFocusedView, margin: margin) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                UIView.setAnimationDuration(duration)
            }
            
            tableView.setContentOffset(offset, animated: false)
            UIView.commitAnimations()
        }
    }
    
    func adjustScrollView(scrollView: UIScrollView, forKeyboardInfo info: [NSObject : AnyObject], margin: CGFloat) {
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() else { return }
        
        let convertedFrame = scrollView.window!.convertRect(keyboardFrame, toView: scrollView)
        let actualHeight = contentHeight(scrollView)
        
        // Test keyboard visible
        if keyboardFrame.minY < UIScreen.mainScreen().bounds.height {
            let heightToAdd = scrollView.bounds.maxY - convertedFrame.minY
            let newContentSize = CGSize(width: scrollView.contentSize.width, height: actualHeight + heightToAdd)
            scrollView.contentSize = newContentSize
        } else {
            scrollView.sizeToFit()
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                UIView.setAnimationDuration(duration)
            }
            
            scrollView.setContentOffset(CGPoint.zero, animated: false)
            UIView.commitAnimations()

        }
        
        if let offset = contentOffsetToClearKeyboard(keyboardFrame, scrollView: scrollView, focusedView: keyboardFocusedView, margin: margin) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                UIView.setAnimationDuration(duration)
            }
            
            scrollView.setContentOffset(offset, animated: false)
            UIView.commitAnimations()
        }
    }
    
    // MARK: - Private
    private func contentOffsetToClearKeyboard(keyboardFrame: CGRect, scrollView: UIScrollView, focusedView: UIView?, margin: CGFloat) -> CGPoint? {
        guard let focused = focusedView else { return nil }
        
        let convertedFrame = scrollView.window!.convertRect(keyboardFrame, toView: scrollView)
        
        var viewFrame = scrollView.convertRect(focused.frame, fromView: focused.superview)
        viewFrame.size.height += margin
        
        if convertedFrame.intersects(viewFrame) {
            let newYOffset = scrollView.contentOffset.y + (viewFrame.maxY - convertedFrame.minY)
            return CGPoint(x: 0.0, y: newYOffset)
        }
        return nil
    }
    
    private func contentHeight(tableView: UITableView) -> CGFloat {
        return tableView.rowHeight * CGFloat(tableView.numberOfRowsInSection(0))
    }
    
    private func contentHeight(scrollView: UIScrollView) -> CGFloat {
        return scrollView.subviews.reduce(0.0) { (height, view) -> CGFloat in
            return (view.frame.maxY > height) ? view.frame.maxY : height
        }
    }
}
