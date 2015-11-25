//
//  UserAccountViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/19/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit

class UserAccountViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Variables and constants
    var userPreferenceFilter = UserPreferenceFilter()
    var forumPosts = [ForumPost]()
    
    //MARK: Outlets
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var currentCityLabel: UILabel!
    @IBOutlet var accountsTableView: UITableView!
    
    
    //MARK: Actions
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(sender: UIBarButtonItem) {
        User.logout()
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
        initialSetUp()
        configureTableView()
        initiateLoader()
        apiGetForumPostsHandler { () -> Void in
        }
        
    }
    
    //MARK: Helper functions
    
    func configureTableView() {
        accountsTableView.rowHeight = UITableViewAutomaticDimension
        accountsTableView.estimatedRowHeight = 160.0
    }
    
    func initialSetUp() {
        guard let currentUser = User.currentUser() else {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        userNameLabel.text = currentUser.username
    }
    /**
    Function is initiated when the current location button is selected
    */
    func getCurrentLocation() {
        if userPreferenceFilter.checkForLocationPreference() {
            userPreferenceFilter.getCurrentLocationCoordinates({ () -> Void in
            })
        }
        getAddressStringFromCoordinates()
    }
    
    /**
    Display current location alert if current location is currently turned off
    */
    func displayLocationAlert() {
        let alertController = UIAlertController(title: "Current Location Turned Off", message:
            "Sorry, you need to turn on Current Location for Underbored to use this feature", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
    Function is a reverse geocoder that grabs the current location based on user coordinates
    */
    func getAddressStringFromCoordinates() {
        let location = userPreferenceFilter.defaultLocation
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            guard error == nil, let initialLocation = (placemarks?.first as CLPlacemark?) else {
                self.currentCityLabel.text = "Los Angeles"
                return
            }
            self.currentCityLabel.text = initialLocation.locality
        })
    }
    
    /**
    Function makes API call and handles the response JSON and parses the forum data and appends it to [ForumPost] data array.
    */
    func apiGetForumPostsHandler(completion: ()-> Void) {
        if userPreferenceFilter.checkForLocationPreference() {
            userPreferenceFilter.getCurrentLocationCoordinates({ () -> Void in
            })
            userPreferenceFilter.currentLocationOn = true
        }
        
        guard let currentUser = User.currentUser() else {
            closeLoader()
            return
        }
        
        let helper = ForumAPIHelper()
        forumPosts = []
        helper.getAccountForumPostings(currentUser.userId!, completion: { (results, error) -> Void in
            completion()
            self.closeLoader()
            guard error == nil, let results = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, there seems to be a network error. Please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }
            
            guard let statusString = results["status"] as? String where statusString == "successful",
                let resultsArray = results["results"] as? NSArray else {
                    
                    if let possibleError = results["message"] as? String
                    {
                        self.displayAlertMessage(possibleError, titleString: "Server Error")
                    } else {
                        self.displayAlertMessage("Sorry, unknown server side error has occured. Please try again.", titleString: "Server Error")
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
            self.accountsTableView.reloadData()
        })
    }
}

extension UserAccountViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let forumCell = tableView.dequeueReusableCellWithIdentifier("forumCell", forIndexPath: indexPath) as! AccountsTableViewCell
        forumCell.delegate = self
        let forumPost = forumPosts[indexPath.row]
        forumCell.setCell(forumPost)
        return forumCell
    }
}

extension UserAccountViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("forumReplyNavigationController") as! UINavigationController
        let forumPostViewController = navigationController.viewControllers.first as! ForumCommentsViewController
        forumPostViewController.forumPost = forumPosts[indexPath.row]
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

extension UserAccountViewController: AccountsTableViewCellDelegate {
    
    func userHasLiked(cell: AccountsTableViewCell) {
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
                //need to handle network error
                self.displayAlertMessage("Sorry, there seems to be network error. Please try again", titleString: "Network Error")
                return
            }
            
            guard let statusString = responseDictionary["status"] as? String else {
                if let possibleError = responseDictionary["message"] as? String where possibleError == "Unauthorized access"
                {
                    self.displayAlertMessage(possibleError, titleString: "Server Error")
                } else {
                    self.displayAlertMessage("Sorry, unknown server error has occured. Please try again", titleString: "Server Error")
                }
                return
            }
            
            if statusString != "successful" {
                
            } 
            self.forumPosts[cell.tag].userHasLiked = cell.likes
        }
    }
    
}

