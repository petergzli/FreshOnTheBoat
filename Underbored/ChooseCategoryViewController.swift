//
//  ChooseCategoryViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/17/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

protocol ChooseCategoryViewControllerDelegate {
    func userHasChosenCategory(category: Category)
}

class ChooseCategoryViewController: UIViewController {
    
    //MARK: Constants and variables
    var delegate: ChooseCategoryViewControllerDelegate?
    
    //MARK: Outlets
    @IBOutlet var shoppingView: UIView!
    @IBOutlet var foodView: UIView!
    @IBOutlet var generalView: UIView!
    @IBOutlet var entertainmentView: UIView!
    
    //MARK: Actions
    @IBAction func entertainmentButtonTapped(sender: UIButton) {
        categoryChosen(Category.Entertainment)
    }
    
    @IBAction func shoppingButtonTapped(sender: UIButton) {
        categoryChosen(Category.Shopping)
    }
    
    @IBAction func foodButtonTapped(sender: UIButton) {
        categoryChosen(Category.Food)
    }
    
    @IBAction func generalButtonTapped(sender: UIButton) {
        categoryChosen(Category.General)
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        initiateViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUpNavigationController()
    }
    
    
    //MARK: Helper functions
    
    /**
    Function dismisses the view controller, either with a navigation controller or a modal dismiss
    */
    func backButtonTapped() {
        if navigationController != nil {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /**
    Function sets up the navigation controller with the back button as well as a title
    */
    func setUpNavigationController() {
        let backButton = UIBarButtonItem(image: UIImage(named: "header-back-button"), style: .Plain, target: self, action: "backButtonTapped")
        
        backButton.title = ""
        if navigationController != nil {
            navigationItem.leftBarButtonItem = backButton
            navigationItem.title = "Choose Category"
        }
    }
    
    /**
    Function chooses category and then dismisses view controller.

    - Parameter category: The category that was chosen
    */
    func categoryChosen(category: Category) {
        delegate?.userHasChosenCategory(category)
        if navigationController != nil {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /**
    Function that sets up the views to be circles
    */
    func initiateViews() {
        shoppingView.layer.cornerRadius = shoppingView.frame.size.width/2
        foodView.layer.cornerRadius = foodView.frame.size.width/2
        generalView.layer.cornerRadius = generalView.frame.size.width/2
        entertainmentView.layer.cornerRadius = entertainmentView.frame.size.width/2
    }
}