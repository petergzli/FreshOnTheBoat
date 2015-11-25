//
//  ForumCommentsViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/21/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit
import AmazonS3RequestManager

class ForumCommentsViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: Variables and constants
    var newForumPostComment = ForumPostComment(body: nil)
    var forumPost: ForumPost!
    var userPreferenceFilter: UserPreferenceFilter!
    var forumPostComments = [ForumPostComment]()
    let imagePicker = UIImagePickerController()
    var refreshControl: UIRefreshControl!
    let textViewActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    var keyboardMoved = false
    var optionalBarDidAppear = false
    var postButtonAppeared = false
    
    //MARK: Outlets
    @IBOutlet var forumCommentsTableView: UITableView!
    @IBOutlet var forumBodyCommentSuperView: UIView!
    @IBOutlet var forumBodyExtraDetailsButton: UIButton!
    @IBOutlet var forumBodyCommentTextView: UITextView!
    @IBOutlet var postCommentAreaViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var optionalAttachedPhotoButton: UIButton!
    @IBOutlet var optionalPinLocationButton: UIButton!
    @IBOutlet var optionalDetailsBlurView: UIVisualEffectView!
    @IBOutlet var optionalDetailsBottomViewConstraint: NSLayoutConstraint!
    @IBOutlet var postCommentButton: UIButton!
    
    //MARK: Actions
    @IBAction func pinLocationButtonTapped(sender: UIButton) {
        forumBodyCommentTextView.resignFirstResponder()
        let pinLocationViewController = UIStoryboard(name: "NewForum", bundle: nil).instantiateViewControllerWithIdentifier("pinLocationViewController") as! PinLocationViewController
        pinLocationViewController.delegate = self
        if let locationPin = newForumPostComment.locationPinned {
            pinLocationViewController.userPreferenceFilter.defaultLocation = locationPin
        } else {
            pinLocationViewController.userPreferenceFilter = userPreferenceFilter
        }
        
        navigationController?.pushViewController(pinLocationViewController, animated: true)
    }
    
    @IBAction func attachPhotoButtonTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            forumBodyCommentTextView.resignFirstResponder()
            imagePicker.allowsEditing = false //2
            imagePicker.sourceType = .PhotoLibrary //3
            presentViewController(imagePicker, animated: true, completion: nil)//4
        }
    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        guard User.currentUser() != nil else {
            forumBodyCommentTextView.resignFirstResponder()
            presentViewControllerHelper(nil, viewControllerIdentifier: "LoginViewController", storyboardIdentifier: "User")
            return
        }
        
        guard forumBodyCommentTextView.text.characters.count > 0 else {
            return
        }
        
        let body = forumBodyCommentTextView.text
        newForumPostComment.body = body
        newForumPostComment.forumId = forumPost.forumId
        forumBodyCommentTextView.resignFirstResponder()
        
        postCommentButton.enabled = false
        setUpLoaderInTextView()
        if postButtonAppeared {
            postCommentAreaViewBottomConstraint.constant = -48
            postButtonAppeared = !postButtonAppeared
        }
        
        if newForumPostComment.attachedPhoto != nil {
            newForumPostComment.imageURL = photoImageName()
            awsUploadImage(newForumPostComment.attachedPhoto!, imageName: newForumPostComment.imageURL!)
        }
        
        apiPostComment()
    }
    
    @IBAction func detailsButtonTapped(sender: UIButton) {
        animateDetailsBar()
    }
    
    //MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        initiateLoader()
        getForumCommentsAPICall { () -> Void in}
        setKeyboardObservers()
        configureTableView()
        setUpRefresh()
        imagePicker.delegate = self
    }
    
    //MARK: API Helper functions
    
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
        
        let photoImageName = "forumPostComments" + userName + dateString + ".jpeg"
        return photoImageName
    }
    
    /**
    Function to make new post request
    */
    func apiPostComment(usePassword: Bool = true) {
        guard let newForumpost = newForumPostComment as ForumPostComment?, let currentUser = User.currentUser() else {
            postCommentButton.enabled = true
            removeActivityIndicator()
            return
        }
        
        let helper = ForumAPIHelper()
        helper.postNewForumComment(currentUser, forumPostComment: newForumpost, usePassword: usePassword, completion: { (results, error) -> Void in
            self.postCommentButton.enabled = true
            self.removeActivityIndicator()
            guard error == nil, let results = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, unknown network error has occured. Please try again. \n Error: \(error)", titleString: "Network Error")
                
                return
            }
            
            guard let statusString = results["status"] as? String where statusString == "successful", let newForumPostId = results["id"] as? Int else {
                
                if let possibleError = results["message"] as? String where possibleError == "Unauthorized access"
                {
                    self.apiPostComment(true)
                    self.displayAlertMessage("Sorry, server error has occured. \n Error: \(possibleError)", titleString: "Server Error")
                    
                } else {
                    self.displayAlertMessage("Sorry, unknown server error has occured, please try again", titleString: "Server Error")
                }
                return
            }
            
            newForumpost.id = newForumPostId
            newForumpost.posterUsername = currentUser.username
            newForumpost.posterId = currentUser.userId
            self.forumPostComments.insert(newForumpost, atIndex: 0)
            self.forumCommentsTableView.reloadData()
            self.resetPostComments()
        })
    }
    
    /**
    Function makes API call and populates forumPostComments datasource
    */
    func getForumCommentsAPICall(completion:()->Void) {
        let forumAPIHelper = ForumAPIHelper()
        
        forumAPIHelper.getForumComments(forumPost.forumId!, repliedToForumId: nil) { (results, error) -> Void in
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
            self.forumPostComments = []
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
                
                if let totalReplies = commentDictionary["total_replies"] as? Int {
                    forumPostComment.totalReplies = totalReplies
                }
                
                if let totalLikes = commentDictionary["total_likes"] as? Int {
                    forumPostComment.totalLikes = totalLikes
                }
                
                if let userHasLiked = commentDictionary["user_has_liked"] as? Int {
                    forumPostComment.userHasLiked = userHasLiked
                }
                
                if let imageURL = commentDictionary["image_url"] as? String where imageURL != "" {
                    forumPostComment.imageURL = imageURL
                }
                if let pinnedLatitude = commentDictionary["location_pin_latitude"] as? Double, let pinnedLongitude = commentDictionary["location_pin_longitude"] as? Double {
                    forumPostComment.locationPinned = CLLocation(latitude: pinnedLatitude, longitude: pinnedLongitude)
                }
                self.forumPostComments.append(forumPostComment)
            }
            self.forumCommentsTableView.reloadData()
        }
    }
    
    //MARK: Other helper functions
    
    func setUpLoaderInTextView() {
        let viewDictionary = ["indicator": textViewActivityIndicator]
        textViewActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        textViewActivityIndicator.frame = forumBodyCommentTextView.bounds
        forumBodyCommentTextView.addSubview(textViewActivityIndicator)
        textViewActivityIndicator.tintColor = Colors.redPurple
        let loaderConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[indicator]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
        let textViewActivityIndicatorY = NSLayoutConstraint.init(item: textViewActivityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: textViewActivityIndicator.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        forumBodyCommentTextView.addConstraint(textViewActivityIndicatorY)
        forumBodyCommentTextView.addConstraints(loaderConstraintsH)
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
        forumCommentsTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        getForumCommentsAPICall { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    /**
    Function resets the post comments area, by retracting everything to default states
    */
    func resetPostComments() {
        optionalDetailsBottomViewConstraint.constant -= 200
        renderButtonImageView(optionalPinLocationButton, imageName: "newforum-choose-location", color: Colors.lightGrey)
        forumBodyCommentTextView.text = nil
        newForumPostComment = ForumPostComment(body: nil)
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
        self.TextViewIsReset()
    }
    
    /**
    Sets up Navigation bar color
    */
    
    func setUpViews() {
        optionalPinLocationButton.layer.cornerRadius = 5
        optionalAttachedPhotoButton.layer.cornerRadius = 5
        forumBodyCommentTextView.layer.cornerRadius = 5
        forumBodyExtraDetailsButton.layer.cornerRadius = forumBodyExtraDetailsButton.bounds.height/2
        postCommentAreaViewBottomConstraint.constant -= 48
        optionalDetailsBottomViewConstraint.constant -= 200
        optionalDetailsBlurView.effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        renderButtonImageView(optionalPinLocationButton, imageName: "newforum-choose-location", color: Colors.lightGrey)
    }
    
    /**
    Function animates the detail bar up
    */
    func animateDetailsBar() {
        if !optionalBarDidAppear {
            optionalDetailsBottomViewConstraint.constant = 0
            UIView.animateWithDuration(0.25, delay: 0, options: [.CurveEaseInOut], animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            optionalDetailsBottomViewConstraint.constant -= 500
            UIView.animateWithDuration(0.25, delay: 0, options: [.CurveEaseInOut], animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
        optionalBarDidAppear = !optionalBarDidAppear
    }
    
    /**
    Function sets up the table view for automatic dynamic cell size
    */
    func configureTableView() {
        forumCommentsTableView.rowHeight = UITableViewAutomaticDimension
        forumCommentsTableView.estimatedRowHeight = 160.0
    }
    
    func flagButtonTapped() {
        guard !forumPost.userHasFlagged else {
            self.displayAlertMessage("Sorry, you have already flagged this post.", titleString: "User Flagged")
            return
        }
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let titleCell = forumCommentsTableView.cellForRowAtIndexPath(indexPath) as! ForumTitleTableViewCell
        
        guard let currentUser = User.currentUser() else {
            forumBodyCommentTextView.resignFirstResponder()
            presentViewControllerHelper(nil, viewControllerIdentifier: "LoginViewController", storyboardIdentifier: "User")
            return
        }
        
        titleCell.flagIconImageView.hidden = false
        renderImageView(titleCell.flagIconImageView, color: Colors.red)
        
        let helper = ForumAPIHelper()
        helper.postForumFlag(currentUser, forumPostId: forumPost.forumId!) { (results, error) -> Void in
            
            guard error == nil, let responseDictionary = results as? NSDictionary, let responseString = responseDictionary["status"] as? String else {
                self.displayAlertMessage("Sorry, unknown network error has occured, please try again", titleString: "Network Error")
                return
            }
            
            guard responseString == "successful" else {
                self.displayAlertMessage("Sorry, unknown server error has occured, please try again", titleString: "Server Error")
                return
            }
            
            self.forumPost.userHasFlagged = true
            
            //Pop out flag icon
        }
        
    }
}

extension ForumCommentsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumPostComments.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard indexPath.row > 0 else {
            let forumCell = tableView.dequeueReusableCellWithIdentifier("forumTitleCell", forIndexPath: indexPath) as! ForumTitleTableViewCell
            forumCell.setUpForumPostCell(forumPost)
            return forumCell
        }
        let forumCell = tableView.dequeueReusableCellWithIdentifier("forumCommentCell", forIndexPath: indexPath) as! ForumCommentsTableViewCell
        forumCell.delegate = self
        forumCell.setUpForumPostCommentCell(forumPostComments[indexPath.row - 1])
        return forumCell
    }
}

extension ForumCommentsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        guard indexPath.row == 0 else {
            return []
        }
        
        let message = "Flag this post?"
        let title = "Flag"
        guard !forumPost.userHasFlagged else {
            return []
        }
        
        let reportAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "flag" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let rateMenu = UIAlertController(title: nil, message: message, preferredStyle: .ActionSheet)
            let appRateAction = UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.flagButtonTapped()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            rateMenu.addAction(appRateAction)
            rateMenu.addAction(cancelAction)
            self.presentViewController(rateMenu, animated: true, completion: nil)
        })
        
        reportAction.backgroundColor = Colors.redPurpleLight
        return [reportAction]
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard indexPath.row > 0 else {
            return
        }
        
        let commentRepliesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CommentRepliesViewController") as! ForumCommentRepliesViewController
        commentRepliesViewController.forumComment = forumPostComments[indexPath.row - 1]
        commentRepliesViewController.userPreferenceFilter = userPreferenceFilter
        navigationController?.pushViewController(commentRepliesViewController, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        forumBodyCommentTextView.resignFirstResponder()
        if postButtonAppeared {
            postCommentAreaViewBottomConstraint.constant = -48
            postButtonAppeared = !postButtonAppeared
        }
    }
}

extension ForumCommentsViewController: KeyboardObserverType {
    
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
}

extension ForumCommentsViewController: UITextViewDelegate {
    
    func setUpTextView() {
        if !postButtonAppeared {
            postCommentAreaViewBottomConstraint.constant += 48
            UIView.animateWithDuration(0.25) {
                self.view.layoutIfNeeded()
            }
            postButtonAppeared = !postButtonAppeared
        }
    }
    
    func TextViewIsReset() {
        forumBodyCommentTextView.resignFirstResponder()
        forumBodyCommentTextView.text = ""
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

extension ForumCommentsViewController: UIImagePickerControllerDelegate {
    //MARK: Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }

        newForumPostComment.attachedPhoto = chosenImage
        optionalAttachedPhotoButton.contentMode = .ScaleToFill
        optionalAttachedPhotoButton.clipsToBounds = true
        optionalAttachedPhotoButton.setImage(chosenImage, forState: .Normal)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ForumCommentsViewController: PinLocationViewControllerDelegate {
    func userHasPinnedLocation(chosenLocation: CLLocation) {
        newForumPostComment.locationPinned = chosenLocation
        changeButtonViewWhenLocationIsSelected()
    }
    
    /**
    Function changes the background color and image icon of the location button when selected
    */
    func changeButtonViewWhenLocationIsSelected() {
        guard newForumPostComment.locationPinned != nil else {
            return
        }
        renderButtonImageView(optionalPinLocationButton, imageName: "newforum-choose-location", color: Colors.green)
        optionalPinLocationButton.backgroundColor = Colors.bluePurple
    }
}

extension ForumCommentsViewController: ForumCommentsTableViewCellDelegate {
    
    func userHasLiked(cell: ForumCommentsTableViewCell) {
        
        guard let id = cell.forumPostComment.id else {
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
            
            self.forumPostComments[cell.tag].userHasLiked = cell.likes
        }
    }
    
}
