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
<<<<<<< HEAD
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    public func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
=======
    public func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    public func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
>>>>>>> Swift_3.0
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(String(describing: segue.identifier)).") }
        return segueIdentifier
    }
}
