//
//  ForumCommentRepliesViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/24/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit
import AmazonS3RequestManager

class ForumCommentRepliesViewController: UIViewController,UINavigationControllerDelegate, KeyboardObserverType {

    //MARK: Variables and constants
    let imagePicker = UIImagePickerController()
    var newForumCommentReply = ForumPostComment(body: nil)
    var forumComment: ForumPostComment!
    var forumCommentReplies = [ForumPostComment]()
    var userPreferenceFilter = UserPreferenceFilter()
    let textViewActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var refreshControl: UIRefreshControl!
    var keyboardMoved = false
    var optionalBarDidAppear = false
    var postButtonAppeared = false
    
    //MARK: Outlets
    @IBOutlet var forumRepliesTableView: UITableView!
    @IBOutlet var postCommentAreaViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var optionalDetailsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var forumRepliesTextView: UITextView!
    
    @IBOutlet var optionalDetailsButton: UIButton!
    @IBOutlet var optionalPinLocationButton: UIButton!
    @IBOutlet var optionAttachPhotoButton: UIButton!
    
    @IBOutlet var postButton: UIButton!
    //MARK: Actions
    
    @IBAction func postCommentReplyButtonTapped(sender: UIButton) {
        guard User.currentUser() != nil else {
            forumRepliesTextView.resignFirstResponder()
            presentViewControllerHelper(nil, viewControllerIdentifier: "LoginViewController", storyboardIdentifier: "User")
            return
        }
        
        guard forumRepliesTextView.text.characters.count > 0 else {
            return
        }
        
        if newForumCommentReply.attachedPhoto != nil {
            newForumCommentReply.imageURL = photoImageName()
            awsUploadImage(newForumCommentReply.attachedPhoto!, imageName: newForumCommentReply.imageURL!)
        }
        
        postButton.enabled = false
        setUpLoaderInTextView()
        forumRepliesTextView.resignFirstResponder()
        if postButtonAppeared {
            postCommentAreaViewBottomConstraint.constant = -48
            postButtonAppeared = !postButtonAppeared
        }
        
        let body = forumRepliesTextView.text
        newForumCommentReply.body = body
        newForumCommentReply.repliedToForumId = forumComment.id
        newForumCommentReply.forumId = forumComment.forumId
        forumRepliesTextView.resignFirstResponder()
        apiPostComment()
    }
    
    @IBAction func optionalDetailsButtonTapped(sender: UIButton) {
        animateDetailsBar()
    }
    
    @IBAction func pinLocationButtonTapped(sender: UIButton) {
        forumRepliesTextView.resignFirstResponder()
        let pinLocationViewController = UIStoryboard(name: "NewForum", bundle: nil).instantiateViewControllerWithIdentifier("pinLocationViewController") as! PinLocationViewController
        if let locationPin = newForumCommentReply.locationPinned {
            pinLocationViewController.userPreferenceFilter.defaultLocation = locationPin
        } else {
            pinLocationViewController.userPreferenceFilter = userPreferenceFilter
        }
        pinLocationViewController.delegate = self
        navigationController?.pushViewController(pinLocationViewController, animated: true)
    }
    
    @IBAction func attachPhotoButtonTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            forumRepliesTextView.resignFirstResponder()
            imagePicker.allowsEditing = false //2
            imagePicker.sourceType = .PhotoLibrary //3
            presentViewController(imagePicker, animated: true, completion: nil)//4
        }
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
        setKeyboardObservers()
        initiateLoader()
        getForumCommentRepliesAPICall { () -> Void in}
        configureTableView()
        setUpRefresh()
        imagePicker.delegate = self
        
    }
    
    //MARK: API Functions
    
    /**
    Function uploads the image to amazon s3 bucket
    */
    func awsUploadImage(image: UIImage?, imageName: String) {
        let amazonS3Manager = AmazonS3RequestManager(bucket: "underbored",
            region: .USWest1,
            accessKey: "AKIAJJT7XASQEYB7JKCA",
            secret: "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")
        
        guard let image = image, let imageData = UIImageJPEGRepresentation(image, 0.3) as NSData? else {
            displayAlertMessage("Sorry, unknown error has occured. Image could not be handled. Please try again.", titleString: "iPhone Media Error")
            return
        }
        
        amazonS3Manager.putObject(imageData, destinationPath: imageName)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    break
                case .Failure(let error):
                    self.displayAlertMessage("Sorry, there seems to be a problem processing your photo, please try again \n Error: \(error)", titleString: "Media Upload Error")
                }
        }

    }
    
    /**
    Function returns a photoname based on the current time, the current user.
    
    - Returns: String
    */
    func photoImageName() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM_dd_yyyy_HH_mm_ss"
        let dateString = formatter.stringFromDate(date)
        
        guard let currentUser = User.currentUser(), userName = currentUser.username else {
            return "anonymous" + dateString + ".jpeg"
        }
        
        let photoImageName = "forumPostCommentReplies" + userName + dateString + ".jpeg"
        return photoImageName
    }

    
    /**
    Function to make new post request
    */
    func apiPostComment(usePassword: Bool = true) {
        
        guard let newForumpost = newForumCommentReply as ForumPostComment?, let currentUser = User.currentUser() else {
            postButton.enabled = true
            removeActivityIndicator()
            return
        }
        
        let helper = ForumAPIHelper()
        helper.postNewForumComment(currentUser, forumPostComment: newForumpost, usePassword: usePassword, completion: { (results, error) -> Void in
            self.postButton.enabled = true
            self.removeActivityIndicator()
            guard error == nil, let results = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, unknown network error has occured. Please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }
            
            guard let statusString = results["status"] as? String where statusString == "successful", let newForumPostId = results["id"] as? Int else {
                
                if let possibleError = results["message"] as? String where possibleError == "Unauthorized access"
                {
                    self.displayAlertMessage("Sorry, server error has occured. \n Error: \(possibleError)", titleString: "Server Error")
                } else {
                    self.displayAlertMessage("Sorry, unknown server error has occured, please try again", titleString: "Server Error")
                }
                return
            }
            
            newForumpost.id = newForumPostId
            newForumpost.posterId = currentUser.userId
            newForumpost.posterUsername = currentUser.username
            self.forumCommentReplies.insert(newForumpost, atIndex: 0)
            self.forumRepliesTableView.reloadData()
            self.resetPostComments()
        })
    }

    /**
    Function makes API call and populates forumPostComments datasource
    */
    func getForumCommentRepliesAPICall(completion:()->Void) {
        let forumAPIHelper = ForumAPIHelper()
        forumAPIHelper.getForumComments(forumComment.forumId!, repliedToForumId: forumComment.id) { (results, error) -> Void in
            completion()
            self.closeLoader()
            guard error == nil, let responseDictionary = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, unknown network error has occured. Please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }
            
            guard let responseString = responseDictionary["status"] as? String where responseString == "successful", let commentsArray = responseDictionary["results"] as? NSArray else {
                self.displayAlertMessage("Sorry, unknown server error has occured, please try again", titleString: "Server Error")
                return
            }
            
            self.forumCommentReplies = []
            for commentElement in commentsArray {
                
                guard let commentDictionary = commentElement as? NSDictionary, let body = commentDictionary["body"] as? String, let commentId = commentDictionary["id"] as? Int, let posterId = commentDictionary["poster_id"] as? Int, let posterUsername = commentDictionary["poster_username"] as? String, let forumId = commentDictionary["forum_id"] as? Int else {
                    self.displayAlertMessage("Sorry, unknown server error has occured, please try again", titleString: "Server Error")
                    
                    return
                }
                
                let forumPostComment = ForumPostComment(body: body)
                forumPostComment.id = commentId
                forumPostComment.posterId = posterId
                forumPostComment.forumId = forumId
                forumPostComment.posterUsername = posterUsername
                
                if let totalLikes = commentDictionary["total_likes"] as? Int {
                    forumPostComment.totalLikes = totalLikes
                }
                
                if let totalReplies = commentDictionary["total_replies"] as? Int {
                    forumPostComment.totalReplies = totalReplies
                }
                
                if let userHasLiked = commentDictionary["user_has_liked"] as? Int {
                    forumPostComment.userHasLiked = userHasLiked
                }
                
                if let imageURL = commentDictionary["image_url"] as? String {
                    forumPostComment.imageURL = imageURL
                }
                if let pinnedLatitude = commentDictionary["location_pin_latitude"] as? Double, let pinnedLongitude = commentDictionary["location_pin_longitude"] as? Double {
                    forumPostComment.locationPinned = CLLocation(latitude: pinnedLatitude, longitude: pinnedLongitude)
                }
                
                self.forumCommentReplies.append(forumPostComment)
            }
            
            self.forumRepliesTableView.reloadData()
        }
    }
    
    //MARK: Helper functions
    
    func setUpLoaderInTextView() {
        let viewDictionary = ["indicator": textViewActivityIndicator]
        textViewActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        textViewActivityIndicator.frame = forumRepliesTextView.bounds
        forumRepliesTextView.addSubview(textViewActivityIndicator)
        textViewActivityIndicator.tintColor = Colors.redPurple
        let loaderConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[indicator]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
        let textViewActivityIndicatorY = NSLayoutConstraint.init(item: textViewActivityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: textViewActivityIndicator.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        forumRepliesTextView.addConstraint(textViewActivityIndicatorY)
        forumRepliesTextView.addConstraints(loaderConstraintsH)
        textViewActivityIndicator.startAnimating()
    }
    
    func removeActivityIndicator() {
        textViewActivityIndicator.stopAnimating()
        textViewActivityIndicator.removeFromSuperview()
    }
    
    func setUpRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.blue
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        forumRepliesTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        getForumCommentRepliesAPICall { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    /**
    Function resets the post comments area, by retracting everything to default states
    */
    func resetPostComments() {
        optionalDetailsViewBottomConstraint.constant -= 200
        renderButtonImageView(optionalPinLocationButton, imageName: "newforum-choose-location", color: Colors.lightGrey)
        forumRepliesTextView.text = nil
        newForumCommentReply = ForumPostComment(body: nil)
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
        TextViewIsReset()
    }
    
    /**
    Function animates the detail bar up
    */
    func animateDetailsBar() {
        if !optionalBarDidAppear {
            optionalDetailsViewBottomConstraint.constant = 0
            UIView.animateWithDuration(0.25, delay: 0, options: [.CurveEaseInOut], animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            optionalDetailsViewBottomConstraint.constant -= 500
            UIView.animateWithDuration(0.25, delay: 0, options: [.CurveEaseInOut], animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
        optionalBarDidAppear = !optionalBarDidAppear
    }
    
    /**
    Function dismisses the view controller, either with a navigation controller or a modal dismiss
    */
    func backButtonTapped() {
        resignTextFieldKeyboard()
        if navigationController != nil {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func returnButtonTapped() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /**
    Function sets up the navigation controller with the back button as well as a title
    */
    func setUpNavigationController() {
        let backButton = UIBarButtonItem(image: UIImage(named: "header-back-button"), style: .Plain, target: self, action: "backButtonTapped")
        backButton.title = ""
        let returnButton = UIBarButtonItem(image: UIImage(named: "return-icon"), style: .Plain, target: self, action: "returnButtonTapped")
        if navigationController != nil {
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = returnButton
        }
        
        optionalDetailsViewBottomConstraint.constant = -500
        postCommentAreaViewBottomConstraint.constant -= 48
        optionalPinLocationButton.layer.cornerRadius = 5
        optionAttachPhotoButton.layer.cornerRadius = 5
        renderButtonImageView(optionalPinLocationButton, imageName: "newforum-choose-location", color: Colors.lightGrey)
        optionalDetailsButton.layer.cornerRadius = optionalDetailsButton.bounds.height/2
    }
    
    /**
    NSNotification functions for keyboard animation to lift the continue button up the height of the keyboard.
    */
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !self.keyboardMoved {
                self.postCommentAreaViewBottomConstraint.constant += keyboardSize.height
                UIView.animateWithDuration(1.0) {
                    self.view.layoutIfNeeded()
                }
                self.keyboardMoved = true
            }
        }
    }
    
    /**
    NSNotification function for keyboard animation to bring down the continue button back to initial state by the height of the keyboard
    */
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if self.keyboardMoved {
                
                self.postCommentAreaViewBottomConstraint.constant -= keyboardSize.height
                UIView.animateWithDuration(1.0) {
                    self.view.layoutIfNeeded()
                }
                self.keyboardMoved = false
            }
        }
    }
    
    /**
    Function sets up the table view for automatic dynamic cell size
    */
    func configureTableView() {
        forumRepliesTableView.rowHeight = UITableViewAutomaticDimension
        forumRepliesTableView.estimatedRowHeight = 160.0
    }
    
    /**
    Function to resign keyboard
    */
    func resignTextFieldKeyboard() {
        forumRepliesTableView.resignFirstResponder()
    }
}

extension ForumCommentRepliesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumCommentReplies.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row > 0 {
            let forumCommentReplyCell = tableView.dequeueReusableCellWithIdentifier("ForumRepliesReplyTableViewCell", forIndexPath: indexPath) as! ForumRepliesReplyTableViewCell
            forumCommentReplyCell.delegate = self
            forumCommentReplyCell.setUpForumCommentReplyCell(forumCommentReplies[indexPath.row - 1])
            return forumCommentReplyCell
        } else {
            let forumTitleCell = tableView.dequeueReusableCellWithIdentifier("forumRepliesTitleTableViewCell", forIndexPath: indexPath) as! ForumRepliesTitleTableViewCell
            forumTitleCell.setUpCommentTitleCell(forumComment)
            return forumTitleCell
        }
    }
}

extension ForumCommentRepliesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        resignTextFieldKeyboard()
        guard indexPath.row > 0 else {
            return
        }
        
        let commentRepliesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CommentRepliesViewController") as! ForumCommentRepliesViewController
        commentRepliesViewController.forumComment = forumCommentReplies[indexPath.row - 1]
        navigationController?.pushViewController(commentRepliesViewController, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        forumRepliesTextView.resignFirstResponder()
        if postButtonAppeared {
            postCommentAreaViewBottomConstraint.constant = -48
            postButtonAppeared = !postButtonAppeared
        }
    }
}

extension ForumCommentRepliesViewController: UITextViewDelegate {
    
    /** 
    Function to bring the post button to bring the post button to visible state when something is written in text view
    */
    func setUpTextView() {
        if !postButtonAppeared {
            postCommentAreaViewBottomConstraint.constant += 48
            UIView.animateWithDuration(0.25) {
                self.view.layoutIfNeeded()
            }
            postButtonAppeared = !postButtonAppeared
        }
    }
    
    /**
    Function to reset the button to its default state under the screen
    */
    
    func TextViewIsReset() {
        forumRepliesTextView.resignFirstResponder()
        forumRepliesTextView.text = ""
        if postButtonAppeared {
            postCommentAreaViewBottomConstraint.constant -= 48
            UIView.animateWithDuration(0.25) {
                self.view.layoutIfNeeded()
            }
            postButtonAppeared = !postButtonAppeared
        }
    }
    
    /**
    Text view delegate to begin animation
    */
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        setUpTextView()
        let newLength = (textView.text.utf16).count + (text.utf16).count - range.length
        
        guard text != "\n" && newLength <= 200 else {
            return false
        }
        
        return newLength <= 200
    }
}

extension ForumCommentRepliesViewController: PinLocationViewControllerDelegate {
    
    func userHasPinnedLocation(chosenLocation: CLLocation) {
        newForumCommentReply.locationPinned = chosenLocation
        changeButtonViewWhenLocationIsSelected()
    }
    
    /**
    Function changes the background color and image icon of the location button when selected
    */
    func changeButtonViewWhenLocationIsSelected() {
        guard newForumCommentReply.locationPinned != nil else {
            return
        }
        renderButtonImageView(optionalPinLocationButton, imageName: "newforum-choose-location", color: Colors.green)
        optionalPinLocationButton.backgroundColor = Colors.bluePurple
    }
}

extension ForumCommentRepliesViewController: UIImagePickerControllerDelegate {
    //MARK: Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        newForumCommentReply.attachedPhoto = chosenImage
        optionAttachPhotoButton.contentMode = .ScaleAspectFill
        optionAttachPhotoButton.clipsToBounds = true
        optionAttachPhotoButton.setImage(chosenImage, forState: .Normal)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ForumCommentRepliesViewController: ForumRepliesReplyTableViewCellDelegate {
    func userHasLiked(cell: ForumRepliesReplyTableViewCell) {
        
        //Make api call
        //update user model?
        guard let id = cell.forumPostCommentReply.id else {
            displayAlertMessage("Sorry, unknown error has occured. Please try again", titleString: "Unknown Error")
            return
        }
        
        guard let currentUser = User.currentUser() else {
            presentViewControllerHelper(nil, viewControllerIdentifier: "LoginViewController", storyboardIdentifier: "User")
            return
        }
        if cell.likes > 0 {
            cell.heartLikedSpringAnimation()
        } else {
            cell.heartHasDislikedSpringAnimation()
        }
        let helper = ForumAPIHelper()
        
        helper.postForumCommentLike(cell.likes, user: currentUser, forumCommentPostId: id, usePassword: true) { (results, error) -> Void in
            guard error == nil, let responseDictionary = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, unknown network error has occured, please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }
            
            guard let statusString = responseDictionary["status"] as? String else {
                if let possibleError = responseDictionary["message"] as? String where possibleError == "Unauthorized access"
                {
                    self.displayAlertMessage("Sorry, unknown server error has occured, please try again. \n Error: \(possibleError)", titleString: "Server Error")
                    
                } else {
                    self.displayAlertMessage("Sorry, unknown server error has occured, please try again", titleString: "Server Error")
                }
                
                return
            }
            
            if statusString != "successful" {
                
            }
            self.forumCommentReplies[cell.tag].userHasLiked = cell.likes
        }
    }
}