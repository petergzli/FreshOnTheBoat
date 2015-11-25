//
//  KeyBoardObserverType.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/15/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import UIKit

// Protocol extension to handle using enums for segue identifiers
protocol KeyboardObserverType {
    func keyboardWillHide(notification: NSNotification)
    func keyboardWillShow(notification: NSNotification)
}

extension KeyboardObserverType where
Self: UIViewController {
    /**
    Overloading performSegueWithIdentifier to translate the passed in enum to use its raw value as the identifier
    */
    func setKeyboardObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
}