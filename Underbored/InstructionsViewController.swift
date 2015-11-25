//
//  InstructionsViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 10/17/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

enum InstructionsPage: Int {
    case Page1      = 1
    case Page2      = 2
    case Page3      = 3
    case Page4      = 4
}

class InstructionsViewController: UIViewController {
    
    //MARK: Constants and variables
    var pageViewController: UIPageViewController?
    
    //MARK: Outlets
    @IBOutlet var instructionsTextLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var cancelButton: UIButton!

    //MARK: Actions
    @IBAction func cancelButtonTapped(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let containerViewController = storyboard.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        presentViewController(containerViewController, animated: true, completion: nil)
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        renderButtonImageView(cancelButton, imageName: "cancel-button", color: UIColor.whiteColor())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        pageViewController = segue.destinationViewController as? UIPageViewController;
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instructionsChildViewController = storyboard.instantiateViewControllerWithIdentifier("InstructionsChildViewController") as! InstructionsChildViewController
        
        pageViewController!.setViewControllers([instructionsChildViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    //MARK: Helper functions
    
    /**
    Function helps to initiate the subsequent view controllers given the instructionsPage index. The view controller's respective InstructionsPage index is changed to the index of choice and the viewDidAppear methods will prepare the image and descriptions automatically.
    
    - Parameter instructionsPage: This is the category enum that is assigned an index based on their respective "page" in the page view
    
    - Returns: UIViewController
    */
    
    func setUpInstructionsChildViewController(instructionsPage: InstructionsPage) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instructionsChildViewController = storyboard.instantiateViewControllerWithIdentifier("InstructionsChildViewController") as! InstructionsChildViewController
        
        switch instructionsPage {
        case .Page1, .Page2, .Page3, .Page4:
            instructionsChildViewController.currentInstructionsPage = instructionsPage
            return instructionsChildViewController
        }
    }
    
    /**
    Function animates the text with the given string to be animated in the instructionsLabel
    - Parameter string: the string to be written to the label and then animated
    */
    func animateText(string: String) {
        instructionsTextLabel.alpha = 0
        instructionsTextLabel.text = string
        UIView.animateWithDuration(0.5, animations: {
            self.instructionsTextLabel.alpha = 1
        })
    }
    
    /**
    Function changes the text associated with the given texts.
    - Parameter currentPage: the integer value of the current page
    */
    
    func changeText(currentPage: Int) {
        let currentInstructionsPage = InstructionsPage.init(rawValue: currentPage)
        
        switch currentInstructionsPage! {
        case .Page1:
            animateText("Underbored is an app designed to help users better understand their city, one question at a time")
        case .Page2:
            animateText("Ask a question about your city, and let users around you answer them")
        case .Page3:
            animateText("Questions and posts are sorted by four distinct categories")
        case .Page4:
            animateText("Swipe right to like a post, and swipe left to dislike")
        }
    }

}

extension InstructionsViewController: UIPageViewControllerDataSource {
    
    /**
    Delegate function sets up the prior view controllers given the current page
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let pageViewController = viewController as? InstructionsChildViewController
        let instructionsPageCurrentPage = InstructionsPage.init(rawValue: (pageViewController?.currentPage)!)!
        
        switch instructionsPageCurrentPage {
        case .Page1:
            return nil
        case .Page2:
            return setUpInstructionsChildViewController(.Page1)
        case .Page3:
            return setUpInstructionsChildViewController(.Page2)
        case .Page4:
            return setUpInstructionsChildViewController(.Page3)
        }
    }
    
    /**
    Delegate function. Gets the current page and then sets up the next view controllers
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let pageViewController = viewController as? InstructionsChildViewController
        let instructionsPageCurrentPage = InstructionsPage.init(rawValue: (pageViewController?.currentPage)!)!
        
        switch instructionsPageCurrentPage {
        case .Page1:
            return setUpInstructionsChildViewController(.Page2)
        case .Page2:
            return setUpInstructionsChildViewController(.Page3)
        case .Page3:
            return setUpInstructionsChildViewController(.Page4)
        case .Page4:
            return nil
        }
    }
}

extension InstructionsViewController: UIPageViewControllerDelegate {
    
    /**
    Delegate method to keep track of current index and update the page controller
    */
    func pageViewController(InstructionsViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers pageViewController: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        } else {
            let instructionsViewController = InstructionsViewController.viewControllers?.first as? InstructionsChildViewController
            if let currentPage = instructionsViewController?.currentPage as Int? {
                pageControl.currentPage = currentPage - 1
                changeText(currentPage)
            }
        }
    }
}
