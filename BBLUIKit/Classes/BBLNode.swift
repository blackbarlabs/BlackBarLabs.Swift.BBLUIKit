//
//  BBLNode.swift
//  BBLUIKit
//
//  Created by Joel Perry on 10/10/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import UIKit

open class BBLNodeViewModel: Equatable {
    public var identifier: UUID
    
    public init(identifier: UUID) {
        self.identifier = identifier
    }
    
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
    public var fetchChildren: (() -> Void)?
    
    public var canBeExpanded: Bool {
        get {
            switch children {
            case .none:
                return false
                
            case .some(let c):
                return !c.isEmpty
            }
        }
    }
    
    public var descendants: [BBLNodeViewModel] {
        get {
            return children?.reduce([BBLNodeViewModel](), { (result, model) -> [BBLNodeViewModel] in
                return result + [ model ] + model.descendants
            }) ?? []
        }
    }
    
    open func cell(forTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public static func == (lhs: BBLNodeViewModel, rhs: BBLNodeViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: -
public protocol BBLNodeViewDataSource: class {
    var viewModelDidChange: ((IndexPath) -> Void)? { get set }
    var viewModelDidExpand: ((IndexPath, [IndexPath]) -> Void)? { get set }
    var viewModelDidCollapse: ((IndexPath, [IndexPath]) -> Void)? { get set }
    var viewModels: [BBLNodeViewModel] { get set }
}

public extension BBLNodeViewDataSource {
    public var itemCount: Int { return viewModels.count }
    
    public func modelAtIndexPath(_ indexPath: IndexPath) -> BBLNodeViewModel {
        return viewModels[indexPath.row]
    }
    
    public func indexPathForModel(_ model: BBLNodeViewModel) -> IndexPath? {
        guard let row = viewModels.index(where: { $0 == model }) else { return nil }
        return IndexPath(row: row, section: 0)
    }
    
    public func toggleDisclosure(atIndexPath indexPath: IndexPath) {
        let model = modelAtIndexPath(indexPath)
        
        if model.canBeExpanded {
            if model.isExpanded {
                collapseCellsForModel(model, atIndexPath: indexPath) { [weak self] (paths) in
                    self?.viewModelDidCollapse?(indexPath, paths)
                }
            } else {
                expandCellsForModel(model, atIndexPath: indexPath) { [weak self] (paths) in
                    self?.viewModelDidExpand?(indexPath, paths)
                }
            }
        }
    }
    
    // MARK: Private
    private func expandCellsForModel(_ model: BBLNodeViewModel, atIndexPath indexPath: IndexPath,
                                     callback: @escaping ([IndexPath]) -> Void) {
        model.isExpanded = true
        let paths: [IndexPath] = model.descendants.filter({ $0.parent?.isExpanded ?? false }).enumerated().map { (offset, model) in
            let i = indexPath.row + offset + 1
            viewModels.insert(model, at: i)
            if model.children == nil { model.fetchChildren?() }
            return IndexPath(row: i, section: 0)
        }
        callback(paths)
    }
    
    private func collapseCellsForModel(_ model: BBLNodeViewModel, atIndexPath indexPath: IndexPath,
                                       callback: @escaping ([IndexPath]) -> Void) {
        let collapseRange = rangeToCollapse(model: model, indexPath: indexPath)
        viewModels.removeSubrange(collapseRange)
        model.isExpanded = false
        let paths = collapseRange.map { IndexPath(row: $0, section: 0) }
        callback(paths)
    }
    
    private func rangeToCollapse(model: BBLNodeViewModel, indexPath: IndexPath) -> CountableRange<Int> {
        var endIndex = indexPath.row + 1
        while endIndex < viewModels.count && viewModels[endIndex].level > model.level { endIndex += 1 }
        return (indexPath.row + 1)..<endIndex
    }
}
