//
//  SegueHandler.swift
//  OrderOwl
//
//  Created by Joel Perry on 6/12/16.
//  Copyright © 2016 East Five. All rights reserved.
//
//  From https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

import UIKit

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).") }
        return segueIdentifier
    }
}
