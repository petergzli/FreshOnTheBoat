//
//  TermsViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 10/18/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var termsTextContainerView: UIView!
    @IBOutlet var backButton: UIButton!
    
    //MARK: Actions
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        termsTextContainerView.layer.cornerRadius = 5
        renderButtonImageView(backButton, imageName: "header-back-button", color: Colors.redPurple)
    }
}
