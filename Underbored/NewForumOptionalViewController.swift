//
//  NewForumOptionalViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/16/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit
import AmazonS3RequestManager

class NewForumOptionalViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: Variables and constants
    var forumPost: ForumPost!
    let imagePicker = UIImagePickerController()
    var userPreferenceFilter: UserPreferenceFilter!
    var viewsAnimated = false
    var descriptionTextEdited = false
    var keyboardMoved = false
    
    //MARK: Outlets
    @IBOutlet var contentViewAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet var contentViewToSuperViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionViewToTrailingContentViewConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var choosePhotoView: UIView!
    @IBOutlet var chooseLocationView: UIView!
    @IBOutlet var chooseCategoryView: UIView!
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var writeADescriptionImageView: UIImageView!
    @IBOutlet var chooseCategoryImageView: UIImageView!
    @IBOutlet var pinLocationImageView: UIImageView!
    @IBOutlet var writeADescriptionLabel: UILabel!
    @IBOutlet var attachPhotoImageView: UIImageView!
    @IBOutlet var attachPhotoLabel: UILabel!
    @IBOutlet var postButtonBottomConstraint: NSLayoutConstraint!
    
    //MARK: Actions
    @IBAction func postButtonTapped(sender: UIButton) {
        descriptionTextView.resignFirstResponder()
        guard User.currentUser() != nil else {
            presentViewControllerHelper(nil, viewControllerIdentifier: "LoginViewController", storyboardIdentifier: "User")
            return
        }

        if descriptionTextView.text != "" {
            forumPost.forumDescription = descriptionTextView.text
        }
        initiateLoader()
        if forumPost.attachedPhoto != nil {
            forumPost.imageURL = photoImageName()
            awsUploadImage(forumPost.attachedPhoto!, imageName: forumPost.imageURL!)
        }
        
        apiPostForum()
    }
    
    @IBAction func pinALocationTapped(sender: UIButton) {
        descriptionTextView.resignFirstResponder()
        let pinLocationViewController = UIStoryboard(name: "NewForum", bundle: nil).instantiateViewControllerWithIdentifier("pinLocationViewController") as! PinLocationViewController
        pinLocationViewController.delegate = self
        pinLocationViewController.userPreferenceFilter = userPreferenceFilter
        navigationController?.pushViewController(pinLocationViewController, animated: true)
    }

    @IBAction func chooseACategoryTapped(sender: UIButton) {
        descriptionTextView.resignFirstResponder()
        let chooseCategoryViewController = UIStoryboard(name: "NewForum", bundle: nil).instantiateViewControllerWithIdentifier("chooseCategoryViewController") as! ChooseCategoryViewController
        chooseCategoryViewController.delegate = self
        navigationController?.pushViewController(chooseCategoryViewController, animated: true)
    }
    
    @IBAction func attachPhotoButtonTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            descriptionTextView.resignFirstResponder()
            imagePicker.allowsEditing = false //2
            imagePicker.sourceType = .PhotoLibrary //3
            presentViewController(imagePicker, animated: true, completion: nil)//4
        }
    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        descriptionTextView.resignFirstResponder()
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateViews()
        setKeyboardObservers()
        imagePicker.delegate = self
    }
    
    //MARK: Helper functions
    
    func photoImageName() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM_dd_yyyy_HH_mm_ss"
        let dateString = formatter.stringFromDate(date)
        
        guard let currentUser = User.currentUser(), userName = currentUser.username else {
            return "anonymous" + dateString + ".jpeg"
        }
        
        let photoImageName = "forumPost" + userName + dateString + ".jpeg"
        return photoImageName
    }
    
    
    /**
    Function uploads the image to amazon s3 bucket
    */
    func awsUploadImage(image: UIImage?, imageName: String) {
        let amazonS3Manager = AmazonS3RequestManager(bucket: "underbored",
            region: .USWest1,
            accessKey: "AKIAJJT7XASQEYB7JKCA",
            secret: "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")
        
        guard let image = image, let imageData = UIImageJPEGRepresentation(image, 0.3) as NSData? else {
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
    Function makes API call and handles the response JSON and parses the forum data and appends it to [ForumPost] data array.
    */
    func apiPostForum(usePassword: Bool = true) {
        
        guard forumPost != nil, let newForumpost = forumPost as ForumPost? else {
            self.displayAlertMessage("Sorry, unknown error has occured. Please try again", titleString: "Unknown Error")
            return
        }
        
        let helper = ForumAPIHelper()
        helper.postNewForumPost(User.currentUser()!, forumPost: newForumpost, usePassword: usePassword, completion: { (results, error) -> Void in
            self.closeLoader()
            guard error == nil, let results = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, unknown network error has occured. Please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }
            
            guard let statusString = results["status"] as? String where statusString == "successful" else {
                    
                    if let possibleError = results["message"] as? String where possibleError == "Unauthorized access"
                    {
                        self.displayAlertMessage("Sorry, you are not authorized. Please make sure you are signed in", titleString: "Authorization Error")
                        
                        //self.displayErrorString(possibleError)
                    } else {
                        self.displayAlertMessage("Sorry, unknown server error has occured. Please try again", titleString: "Server Error")
                }
                    return
            }
            
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    /**
    Function to round corners and prepare views
    */
    func initiateViews() {
        choosePhotoView.layer.cornerRadius = 8.0
        chooseLocationView.layer.cornerRadius = 8.0
        chooseCategoryView.layer.cornerRadius = 8.0
        attachPhotoImageView.layer.cornerRadius = 8.0
        descriptionView.layer.cornerRadius = 8.0
        renderImageView(pinLocationImageView, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.10))
    }
    
    /**
    Function to animate the views upon button press
    */
    func animateView() {
        if !viewsAnimated {
            contentViewAspectRatioConstraint.constant = 100
            descriptionViewToTrailingContentViewConstraint.constant = 8
            
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                self.attachPhotoLabel.alpha = 0
                self.writeADescriptionLabel.alpha = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
            viewsAnimated = !viewsAnimated
        }
    }
    
    /**
    Function to animate the fade for description
    */
    func animateDescription() {
        if !descriptionTextEdited {
            UIView.animateWithDuration(0, animations: {
                self.writeADescriptionImageView.alpha = 0
                self.writeADescriptionLabel.alpha = 0
            })
            descriptionTextEdited = !descriptionTextEdited
        }
    }
    
    /**
    Function will change the colors and objects of the buttons to indicate added options
    */
    func setUpViewButtons() {
        if forumPost.locationPinned != nil {
            renderImageView(pinLocationImageView, color: Colors.green)
            chooseLocationView.backgroundColor = Colors.bluePurple
        }
        if forumPost.imageURL != nil {
            //show photo in box
        }
        if let selectedCategory = forumPost.category {
            setUpCategoryIconInViewAfterSelection(chooseCategoryImageView, imageViewView: chooseCategoryView, category: selectedCategory)
        }
    }
    
    /**
    Set up category views
    
    - Parameter imageView: Image view containing the icon
    - Parameter imageViewView: View as the backgorund of the imageView
    - Parameter category: The category integer pertaining to the selected category
    */
    func setUpCategoryIconInViewAfterSelection(imageView: UIImageView, imageViewView: UIView, category: Int) {
        let selectedCategory = Category(rawValue: category)
        
        switch selectedCategory! {
        case .Food:
            imageView.image = UIImage(named: "category-food")
            imageViewView.backgroundColor = Colors.blue
        case .Shopping:
            imageView.image = UIImage(named: "category-shopping")
            imageViewView.backgroundColor = Colors.redPurple
        case .Entertainment:
            imageView.image = UIImage(named: "category-entertainment")
            imageViewView.backgroundColor = Colors.bluePurple
        case .General:
            imageView.image = UIImage(named: "category-general")
            imageViewView.backgroundColor = Colors.green
        }
    }

}

extension NewForumOptionalViewController: KeyboardObserverType {
    /**
    NSNotification functions for keyboard animation to lift the continue button up the height of the keyboard.
    */
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !self.keyboardMoved {
                self.postButtonBottomConstraint.constant += keyboardSize.height
                UIView.animateWithDuration(1.0) {
                    self.view.layoutIfNeeded()
                }
                self.keyboardMoved = true
            }
        }
        animateView()
        animateDescription()
    }
    
    /**
    NSNotification function for keyboard animation to bring down the continue button back to initial state by the height of the keyboard
    */
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if self.keyboardMoved {
                self.postButtonBottomConstraint.constant -= keyboardSize.height
                UIView.animateWithDuration(1.0) {
                    self.view.layoutIfNeeded()
                }
                self.keyboardMoved = false
            }
        }
    }
}

extension NewForumOptionalViewController: UIImagePickerControllerDelegate {
    
    //MARK: Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            self.displayAlertMessage("Sorry, image could not be chosen and processed. Please try again.", titleString: "iPhone Media Error")
            return
        }
        
        attachPhotoImageView.image = chosenImage
        attachPhotoImageView.contentMode = .ScaleAspectFill
        attachPhotoImageView.clipsToBounds = true
        forumPost.attachedPhoto = chosenImage
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension NewForumOptionalViewController: PinLocationViewControllerDelegate, ChooseCategoryViewControllerDelegate {
    
    //MARK: Delegate functions
    /**
    Delegate function. Saves the category to the forum post model
    
    - Parameter category, a category from the category enumeration
    */
    func userHasChosenCategory(category: Category) {
        forumPost.category = category.rawValue
        setUpViewButtons()
    }
    
    /**
    Delegate function save the pinned location to the forum post model 

    - Parameter pinnedLocation: CLLocation of the the chosen location from the pin view controller
    */
    func userHasPinnedLocation(pinnedLocation: CLLocation) {
        forumPost.locationPinned = pinnedLocation
        setUpViewButtons()
    }
}