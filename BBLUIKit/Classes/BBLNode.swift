//
//  BBLNode.swift
//  BBLUIKit
//
//  Created by Joel Perry on 10/10/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import UIKit

open class BBLNodeViewModel: NSObject {
    public weak var parent: BBLNodeViewModel?
    public var children: [BBLNodeViewModel]? {
        didSet {
            self.children?.forEach {
                $0.parent = self
                $0.level = self.level + 1
            }
        }
    }
    
    public var level: Int = 0
    public var isExpanded: Bool = false
    public var isSelected: Bool = false
    public var toggleDisclosure: ((BBLNodeViewModel) -> Void)?
    
    public var canBeExpanded: Bool {
        get {
            if children == nil { return false }
            return children!.count > 0
        }
    }
    
    public var descendants: [BBLNodeViewModel] {
        get {
            var result = [BBLNodeViewModel]()
            guard let c = self.children else { return result }
            c.forEach {
                result.append($0)
                result += $0.descendants
            }
            return result
        }
    }
    
    open func cell(forTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: -
open class BBLNodeDataSource {
    public var dataArray = [BBLNodeViewModel]()
    public var displayArray =  [BBLNodeViewModel]()
    
    public var fetchChildren: ((BBLNodeViewModel?, BBLNodeDataSource) -> Void)?
    public var fetchCompletion: ((BBLNodeViewModel?) -> Void)?
    public var toggleDisclosure: ((BBLNodeViewModel) -> Void)?
    
    public var itemCount: Int {
        get { return displayArray.count }
    }
    
    public init() {}
    
    public func modelAtIndexPath(_ indexPath: IndexPath) -> BBLNodeViewModel {
        return displayArray[indexPath.row]
    }
    
    public func expandCellsForModel(_ model: BBLNodeViewModel, atIndexPath indexPath: IndexPath, callback: @escaping ([IndexPath]) -> Void) {
        model.isExpanded = true
        let paths: [IndexPath] = model.descendants.filter({ $0.parent?.isExpanded ?? false }).enumerated().map { (offset, model) in
            let i = indexPath.row + offset + 1
            displayArray.insert(model, at: i)
            if model.children == nil { self.fetchChildren?(model, self) }
            return IndexPath(row: i, section: 0)
        }
        callback(paths)
    }
    
    public func collapseCellsForModel(_ model: BBLNodeViewModel, atIndexPath indexPath: IndexPath, callback: @escaping ([IndexPath]) -> Void) {
        let collapseRange = rangeToCollapse(model: model, indexPath: indexPath)
        displayArray.removeSubrange(collapseRange)
        model.isExpanded = false
        let paths = collapseRange.map { IndexPath(row: $0, section: 0) }
        callback(paths)
    }
    
    public func indexPathForModel(_ model: BBLNodeViewModel) -> IndexPath? {
        guard let row = displayArray.index(where: { $0 == model }) else { return nil }
        return IndexPath(row: row, section: 0)
    }
    
    private func rangeToCollapse(model: BBLNodeViewModel, indexPath: IndexPath) -> CountableRange<Int> {
        var endIndex = indexPath.row + 1
        while endIndex < displayArray.count && displayArray[endIndex].level > model.level { endIndex += 1 }
        return (indexPath.row + 1)..<endIndex
    }
}
