//
//  ContainerViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/15/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit

class ContainerViewController: UIViewController, CLLocationManagerDelegate{

    //MARK: Variables
    
    var currentUser: User?
    var currentUserPreferences = UserPreferenceFilter()
    var forumPosts = [ForumPost]()
    var rootViewController: RootViewController!
    var changeLocationViewController: ChangeLocationViewController!
    
    //MARK: Outlets
    
    @IBOutlet var rootContainerView: UIView!
    @IBOutlet var changeLocationContainerView: UIView!
    
    //MARK: View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        changeLocationContainerView.hidden = true
        changeLocationContainerView.alpha = 0
        
        rootViewController.initiateLoader()
        apiGetForumPostsHandler { () -> Void in
            self.rootViewController.closeLoader()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rootViewControllerSegue" {
            let rootNavigationController = segue.destinationViewController as! UINavigationController
            rootViewController = rootNavigationController.viewControllers.first as! RootViewController
            rootViewController.delegate = self
        } else {
            changeLocationViewController = segue.destinationViewController as! ChangeLocationViewController
            changeLocationViewController.delegate = self
        }
    }
    
    //MARK: Helper functions
    
    /**
    Checks the current location status to see if it was turned on or off
    */
    func checkLocationAuthorizationStatus() {
        if !currentUserPreferences.checkForLocationPreference() {
            currentUserPreferences.locationManager.requestWhenInUseAuthorization()
        } else {
            currentUserPreferences.locationManager.delegate = self
            currentUserPreferences.getCurrentLocationCoordinates({ () -> Void in
            })
            currentUserPreferences.currentLocationOn = true
            changeLocationViewController.userPreferenceFilter.currentLocationOn = true
        }
    }
    
    /**
    Function makes API call and handles the response JSON and parses the forum data and appends it to [ForumPost] data array.
    */
    func apiGetForumPostsHandler(completion: ()-> Void) {
        rootViewController.removeBackgroundImage()
        let helper = ForumAPIHelper()
        forumPosts = []
        helper.getForumPostings(currentUserPreferences, completion: { (results, error) -> Void in
            completion()
            self.rootViewController.closeLoader()
            guard error == nil, let results = results as? NSDictionary else {
                print("Something went horribly wrong! Error: \(error)")
                self.displayAlertMessage("Sorry, there seems to be a network error. Please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }
            
            guard let statusString = results["status"] as? String where statusString == "successful", let resultsArray = results["results"] as? NSArray else {
                    if let possibleError = results["message"] as? String
                    {
                        self.displayAlertMessage(possibleError, titleString: "Server Error")
                    } else {
                        self.displayAlertMessage("Sorry, there seems to be a server error. Please try again.", titleString: "Server Error")
                    }
                    return
            }
            self.forumPosts = []
            for resultsElement in resultsArray {
                guard let forumDictionary = resultsElement as? NSDictionary, let title = forumDictionary["title"] as? String, let latitude = forumDictionary["latitude"] as? Double, let longitude = forumDictionary["longitude"] as? Double, let createdBy = forumDictionary["created_by"] as? String, let createdById = forumDictionary["created_by_id"] as? Int, let forumId = forumDictionary["id"] as? Int  else {
                    print("possible error")
                    return
                }
                
                let forumPost = ForumPost(title: title, postLocation: CLLocation(latitude: latitude, longitude: longitude))
                forumPost.forumId = forumId
                forumPost.createdBy = createdBy
                forumPost.createdById = createdById
                
                if let totalLikes = forumDictionary["total_likes"] as? Int {
                    forumPost.totalLikes = totalLikes
                }
                
                if let totalComments = forumDictionary["total_comments"] as? Int {
                    forumPost.totalComments = totalComments
                }
                
                if let userHasLiked = forumDictionary["user_has_liked"] as? Int {
                    forumPost.userHasLiked = userHasLiked
                }
                
                if let userHasFlagged = forumDictionary["user_has_flagged"] as? Bool {
                    forumPost.userHasFlagged = userHasFlagged
                }
                
                if let category = forumDictionary["category"] as? Int {
                    forumPost.category = category
                }
                
                if let forumDescription = forumDictionary["description"] as? String {
                    forumPost.forumDescription = forumDescription
                }
                if let pinnedLatitude = forumDictionary["location_pin_latitude"] as? Double, pinnedLongitude = forumDictionary["location_pin_longitude"] as? Double {
                    
                    forumPost.locationPinned = CLLocation(latitude: pinnedLatitude, longitude: pinnedLongitude)
                }
                if let imageURL = forumDictionary["image_url"] as? String {
                    forumPost.imageURL = imageURL
                }
                self.forumPosts.append(forumPost)
            }
            
            //Reload tableview
            self.rootViewController.forumPosts = self.forumPosts
            self.rootViewController.currentUserPreferences = self.currentUserPreferences
            self.rootViewController.forumTableView.reloadData()
            
            if self.forumPosts.count == 0 {
                self.rootViewController.addBackgroundImage("Sorry, there are no posts nearby. Be the first to ask a question about your town.")
            }
        })
    }
}

extension ContainerViewController: ChangeLocationViewControllerDelegate {
    
    /**
    Delegate method to close the change location/filter view controller by animating a fade out
    */
    func closeChangeLocationViewController() {
        UIView.animateWithDuration(0.5, animations: {
            self.changeLocationContainerView.alpha = 0
            }, completion: ({ finished in
                self.changeLocationContainerView.hidden = !self.changeLocationContainerView.hidden
            }))
    }
    
    /**
    Delegate function to update the preferences and make a network call with new settings
    
    - Parameter userPreferenceFilter: the passed user preferences.
    */
    func updateUserPreferences(userPreferenceFilter: UserPreferenceFilter) {
        currentUserPreferences.defaultRadius = userPreferenceFilter.defaultRadius
        currentUserPreferences.defaultLocation = userPreferenceFilter.defaultLocation
        currentUserPreferences.currentLocationOn = userPreferenceFilter.currentLocationOn
        closeChangeLocationViewController()
        rootViewController.initiateLoader()
        if let currentUser = User.currentUser() {
            currentUser.defaultUserPreferences = currentUserPreferences
            currentUser.save()
        }
        apiGetForumPostsHandler { () -> Void in
        }
    }
}

extension ContainerViewController: RootViewControllerDelegate {
    
    func refreshData(completion: () -> Void) {
        currentUserPreferences.category = rootViewController.currentCategory
        currentUserPreferences.searchFilter = rootViewController.currentPreference
        apiGetForumPostsHandler { () -> Void in
            completion()
        }
    }
    
    /**
    Delegate function to open the location filter by fading in an animation
    */
    func openChangeLocationViewController() {
        self.changeLocationContainerView.hidden = !self.changeLocationContainerView.hidden
        changeLocationViewController.userPreferenceFilter.currentLocationOn = currentUserPreferences.currentLocationOn
        changeLocationViewController.userPreferenceFilter.defaultLocation = currentUserPreferences.defaultLocation
        changeLocationViewController.initialSetUp()
        UIView.animateWithDuration(0.5, animations: {
            self.changeLocationContainerView.alpha = 1
        })
    }
    
    func newForumPostButtonTapped() {
        let storyboard = UIStoryboard(name: "NewForum", bundle: nil)
        let navController = storyboard.instantiateViewControllerWithIdentifier("newPostNavigationController") as! UINavigationController
        let viewController = navController.viewControllers.first as! NewForumTitleViewController
        viewController.userPreferenceFilter = currentUserPreferences
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func userAccountButtonTapped() {
        if User.currentUser() != nil {
            presentViewControllerHelper("userAccountNavigationController", viewControllerIdentifier: nil, storyboardIdentifier: "User")
        } else {
            presentViewControllerHelper(nil, viewControllerIdentifier: "LoginViewController", storyboardIdentifier: "User")
        }
    }
}