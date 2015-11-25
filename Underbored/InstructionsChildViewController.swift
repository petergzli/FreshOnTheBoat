//
//  InstructionsChildViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 10/17/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

class InstructionsChildViewController: UIViewController {
    
    //MARK: Variables and constants
    
    var currentPage = 1
    var currentInstructionsPage = InstructionsPage.Page1

    //MARK: Outlets
    @IBOutlet var instructionsDisplayImageView: UIImageView!
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController(currentInstructionsPage)
    }
    
    //MARK: Helper functions
    /**
    Function sets up the view controller with a given instructions page
    - Parameter instructionsPage: the enum representing the current page
    */
    func setUpViewController(instructionsPage: InstructionsPage) {
        switch instructionsPage {
        case .Page1:
            currentPage = 1
            instructionsDisplayImageView.image = UIImage(named: "instructions-display-step1")
        case .Page2:
            currentPage = 2
            instructionsDisplayImageView.image = UIImage(named: "instructions-display-step3")
        case .Page3:
            currentPage = 3
            instructionsDisplayImageView.image = UIImage(named: "instructions-display-step1")
        case .Page4:
            currentPage = 4
            instructionsDisplayImageView.image = UIImage(named: "instructions-display-step2")
        }
    }

}
