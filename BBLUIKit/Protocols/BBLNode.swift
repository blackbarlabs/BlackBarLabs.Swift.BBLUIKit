//
//  BBLNode.swift
//  BBLUIKit
//
//  Created by Joel Perry on 10/10/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import UIKit

public protocol BBLNodeViewModel: class {
    weak var parent: Self? { get set }
    var children: [Self]? { get set }
    var level: Int { get set }
    var isExpanded: Bool { get set }
}

public extension BBLNodeViewModel {
    var canBeExpanded: Bool {
        get {
            if children == nil { return false }
            return children!.count > 0
        }
    }
    
    var descendants: [Self] {
        get {
            var result = [Self]()
            guard let c = self.children else { return result }
            c.forEach {
                result.append($0)
                result += $0.descendants
            }
            return result
        }
    }
}

// MARK: -
public protocol BBLNodeDataSource: class {
    associatedtype Model: BBLNodeViewModel
    var dataArray: [Model] { get set }
    var displayArray: [Model] { get set }
    var fetchChildrenCallback: ((Model?) -> Void)? { get set }
    func fetchChildren(_ parent: Model?)
}

public extension BBLNodeDataSource {
    var itemCount: Int {
        get { return displayArray.count }
    }
    
    func modelAtIndexPath(_ indexPath: IndexPath) -> Model {
        return displayArray[indexPath.row]
    }
    
    func expandCellsForModel(_ model: Model, atIndexPath indexPath: IndexPath, callback: @escaping ([IndexPath]) -> Void) {
        model.isExpanded = true
        let paths: [IndexPath] = model.descendants.filter({ $0.parent?.isExpanded ?? false }).enumerated().map { (offset, model) in
            let i = indexPath.row + offset + 1
            displayArray.insert(model, at: i)
            if model.children == nil { self.fetchChildren(model) }
            return IndexPath(row: i, section: 0)
        }
        callback(paths)
    }
    
    func collapseCellsForModel(_ model: Model, atIndexPath indexPath: IndexPath, callback: @escaping ([IndexPath]) -> Void) {
        let collapseRange = rangeToCollapse(model: model, indexPath: indexPath)
        displayArray.removeSubrange(collapseRange)
        model.isExpanded = false
        let paths = collapseRange.map { IndexPath(row: $0, section: 0) }
        callback(paths)
    }

    private func rangeToCollapse(model: Model, indexPath: IndexPath) -> CountableRange<Int> {
        var endIndex = indexPath.row + 1
        while endIndex < displayArray.count && displayArray[endIndex].level > model.level { endIndex += 1 }
        return (indexPath.row + 1)..<endIndex
    }
}
