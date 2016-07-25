//
//  SegueHandler.swift
//  OrderOwl
//
//  Created by Joel Perry on 6/12/16.
//  Copyright © 2016 East Five. All rights reserved.
//
//  From https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

import UIKit

public protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

public extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    public func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    public func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).") }
        return segueIdentifier
    }
}
