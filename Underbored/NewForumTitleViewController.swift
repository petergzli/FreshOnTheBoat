//
//  NewForumTitleViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/15/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

class NewForumTitleViewController: UIViewController {
    
    //MARK: Variables and constants
    var forumPost: ForumPost?
    var userPreferenceFilter: UserPreferenceFilter!
    var keyboardMoved = false
    var directionLabelDissappeared = false
    var textViewSetUp = false
    
    //MARK: Outlets
    @IBOutlet var forumTitleTextView: UITextView!
    @IBOutlet var dividerViewHeight: NSLayoutConstraint!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var continueButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var forumTitleTextViewTopConstraint: NSLayoutConstraint!
    
    //MARK: Actions
    @IBAction func continueButtonTapped(sender: AnyObject) {
        forumTitleTextView.resignFirstResponder()
        if forumTitleTextView.text.characters.count <= 13 {
            print("title should be longer than 30 characters")
        } else {
            forumPost = ForumPost(title: forumTitleTextView.text, postLocation: userPreferenceFilter.defaultLocation)
            performSegueWithIdentifier("titleToOptionalSegue", sender: nil)
        }
    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        forumTitleTextView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarAndViews()
        setKeyboardObservers()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let optionalDetailsController = segue.destinationViewController as! NewForumOptionalViewController
        optionalDetailsController.forumPost = forumPost
        optionalDetailsController.userPreferenceFilter = userPreferenceFilter
    }

    //MARK: Helper functions
    
    /**
    Sets up Navigation bar color
    */
    
    func setUpNavigationBarAndViews() {
        dividerViewHeight.constant = 0.5
        //navigationController?.navigationBar.barTintColor = default
    }
}

extension NewForumTitleViewController: UITextViewDelegate {
    
    func labelDidDissappear() {
        if !directionLabelDissappeared {
            UIView.animateWithDuration(0.25, animations: {
                self.directionLabel.alpha = 0
            })
            directionLabelDissappeared = !directionLabelDissappeared
        }
    }
    
    /**
    Text view delegate to begin animation
    */
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        labelDidDissappear()
        
        let newLength = (textView.text.utf16).count + (text.utf16).count - range.length
        
        if text == "\n" {
            return false
        }
        if newLength >= 200 {
            print("Title should not be more than 200 characters")
        }
        
        return newLength <= 200
    }

}

extension NewForumTitleViewController: KeyboardObserverType {
    
    /**
    Delete textview, and switch to black
    */
    func setUpTextViewArea() {
        if !textViewSetUp {
            forumTitleTextView.text = nil
            forumTitleTextView.textColor = UIColor.blackColor()
            forumTitleTextViewTopConstraint.constant = 0
            UIView.animateWithDuration(0.25, animations: {
                self.view.layoutIfNeeded()
            })
            textViewSetUp = !textViewSetUp
        }
    }
    /**
    NSNotification functions for keyboard animation to lift the continue button up the height of the keyboard.
    */
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !self.keyboardMoved {
                setUpTextViewArea()
                self.continueButtonBottomConstraint.constant += keyboardSize.height
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
                self.continueButtonBottomConstraint.constant -= keyboardSize.height
                UIView.animateWithDuration(1.0) {
                    self.view.layoutIfNeeded()
                }
                self.keyboardMoved = false
            }
        }
    }
}
