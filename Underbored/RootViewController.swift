//
//  RootViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/13/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit

import AmazonS3RequestManager

protocol RootViewControllerDelegate {
    func openChangeLocationViewController()
    func newForumPostButtonTapped()
    func userAccountButtonTapped()
    func refreshData(completion: ()-> Void)
}

class RootViewController: UIViewController {
    //MARK: Variables
    var forumPosts = [ForumPost]()
    var currentCategory = Category.Food
    var currentPreference: SearchFilter = .Hottest
    var currentUserPreferences = UserPreferenceFilter()
    var delegate: RootViewControllerDelegate?
    var refreshControl:UIRefreshControl!
    
    //MARK: Shape objects
    let foodLayer = SquareMorpher()
    let shoppingLayer = SquareMorpher()
    let entertainmentLayer = SquareMorpher()
    let generalLayer = SquareMorpher()
    
    //MARK: Outlets
    @IBOutlet var foodView: UIView!
    @IBOutlet var shoppingView: UIView!
    @IBOutlet var entertainmentView: UIView!
    @IBOutlet var generalView: UIView!
    @IBOutlet var forumTableView: UITableView!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var userPreferenceSegmentedControl: UISegmentedControl!
    
    //MARK: Actions
    @IBAction func foodButtonTapped(sender: UIButton?) {
        
        initiateLoader()
        animateButton(.Food) { () -> Void in
            self.delegate?.refreshData({ () -> Void in
                self.closeLoader()
            })
        }
    }
    
    @IBAction func shoppingButtonTapped(sender: UIButton) {
        
        initiateLoader()
        animateButton(.Shopping) { () -> Void in
            self.delegate?.refreshData({ () -> Void in
                self.closeLoader()
            })
        }
    }
    
    @IBAction func entertainmentButtonTapped(sender: UIButton) {
        
        initiateLoader()
        animateButton(.Entertainment) { () -> Void in
            self.delegate?.refreshData({ () -> Void in
                self.closeLoader()
            })
        }
    }
    
    @IBAction func generalButtonTapped(sender: UIButton) {
        
        initiateLoader()
        animateButton(.General) { () -> Void in
            self.delegate?.refreshData({ () -> Void in
                self.closeLoader()
            })
        }
    }
    
    @IBAction func changeLocationButtonTapped(sender: UIBarButtonItem) {
        delegate?.openChangeLocationViewController()
    }

    @IBAction func userProfileButtonTapped(sender: UIButton) {
        delegate?.userAccountButtonTapped()
    }
    
    @IBAction func addNewForumButtonTapped(sender: UIBarButtonItem) {
        delegate?.newForumPostButtonTapped()
    }
    
    @IBAction func userPreferenceSegmentedControl(sender: UISegmentedControl) {
        initiateLoader()
        switch userPreferenceSegmentedControl.selectedSegmentIndex
        {
        case 0:
            currentPreference = .Hottest
        case 1:
            currentPreference = .Newest
        case 2:
            currentPreference = .Top
        default:
            break; 
        }
        delegate?.refreshData({ () -> Void in
            self.closeLoader()
        })
    }
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        setUpNavigationBar()
        configureTableView()
        initalizer()
    }
    
    override func viewDidAppear(animated: Bool) {
        animateButton(currentUserPreferences.category) { () -> Void in
            self.delegate?.refreshData({ () -> Void in
                self.closeLoader()
            })
        }
    }

    
    //MARK: Helper functions

    func setUpRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.blue
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        forumTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        delegate?.refreshData({ () -> Void in
            self.refreshControl.endRefreshing()
        })
    }

    /**
    Sets up Navigation bar color
    */
    func setUpNavigationBar() {
        //navigationController?.navigationBar.barTintColor = Colors.red
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.image = imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = Colors.redPurple
        navigationItem.titleView = imageView
        renderButtonImageView(profileButton, imageName: "home-userprofile", color: Colors.redPurple)
    }
    
    
    /**
    Function animates the selected button
    
    -Parameter category: Category
    */
    func animateButton(category: Category, completion: ()->Void) {
        switch category {
        case .Food:
            resetButton(currentCategory)
            foodLayer.expand(foodView)
        case .Shopping:
            resetButton(currentCategory)
            shoppingLayer.expand(shoppingView)
        case .Entertainment:
            resetButton(currentCategory)
            entertainmentLayer.expand(entertainmentView)
        case .General:
            resetButton(currentCategory)
            generalLayer.expand(generalView)
        }
        currentCategory = category
        completion()
    }
    
    /**
    Function resets the button's category
    
    :params: category: Category
    */
    func resetButton(category: Category) {
        switch category {
        case .Food:
            foodLayer.contract(foodView)
        case .Shopping:
            shoppingLayer.contract(shoppingView)
        case .Entertainment:
            entertainmentLayer.contract(entertainmentView)
        case .General:
            generalLayer.contract(generalView)
        }
    }
    
    
    /**
    Function adds the custom layers on the views and brings the buttons forward so they appear on top of the view
    */
    func initalizer() {
        addLayerToView(foodView, shapeLayer: foodLayer, color: Colors.blue)
        addLayerToView(shoppingView, shapeLayer: shoppingLayer, color: Colors.bluePurple)
        addLayerToView(entertainmentView, shapeLayer: entertainmentLayer, color: Colors.green)
        addLayerToView(generalView, shapeLayer: generalLayer, color: Colors.red)
    }
    
    
    /**
    Function adds custom layer to current view
    
    :params: view: UIView
    */
    
    func addLayerToView(view: UIView, shapeLayer: SquareMorpher, color: UIColor) {
        shapeLayer.configure(view, color: color)
        view.layer.insertSublayer(shapeLayer, atIndex: 0)
    }
    
    func configureTableView() {
        forumTableView.rowHeight = UITableViewAutomaticDimension
        forumTableView.estimatedRowHeight = 160.0
    }
}

extension RootViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let forumCell = tableView.dequeueReusableCellWithIdentifier("forumCell", forIndexPath: indexPath) as! HomeForumTableViewCell
        forumCell.delegate = self
        let forumPost = forumPosts[indexPath.row]
        forumCell.setCell(forumPost)
        return forumCell
    }
}

extension RootViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("forumReplyNavigationController") as! UINavigationController
        let forumPostViewController = navigationController.viewControllers.first as! ForumCommentsViewController
        forumPostViewController.userPreferenceFilter = currentUserPreferences
        forumPostViewController.forumPost = forumPosts[indexPath.row]
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

extension RootViewController: HomeForumTableViewCellDelegate {
    
    func userHasLiked(cell: HomeForumTableViewCell) {
        //Make api call
        guard let currentUser = User.currentUser() else {
            presentViewControllerHelper(nil, viewControllerIdentifier: "LoginViewController", storyboardIdentifier: "User")

            return
        }
        
        //update user model?
        guard let id = cell.forumPost.forumId else {
            return
        }
        
        if cell.likes > 0 {
            cell.heartLikedSpringAnimation()
        } else {
            cell.heartDislikedSpringAnimation()
        }
        
        let helper = ForumAPIHelper()
        helper.postForumLike(cell.likes, user: currentUser, forumPostId: id, usePassword: true) { (results, error) -> Void in
            guard error == nil, let responseDictionary = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, There seems to be a network error. Please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }
            
            guard let statusString = responseDictionary["status"] as? String else {
                if let possibleError = responseDictionary["message"] as? String where possibleError == "Unauthorized access"
                {
                    self.displayAlertMessage(possibleError, titleString: "Server Error")
                } else {
                    self.displayAlertMessage("Sorry, there seems to be a server error. Please try again", titleString: "Server Error")
                }
                return
            }
            
            if statusString != "successful" {
                
            }
            self.forumPosts[cell.tag].userHasLiked = cell.likes
        }
    }

}

