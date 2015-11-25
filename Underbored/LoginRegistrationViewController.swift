//
//  LoginRegistrationViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/15/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

class LoginRegistrationViewController: UIViewController, KeyboardObserverType {

    //MARK: Variables and constants
    var user: User!
    var keyboardMoved = false
    var newUserMode = false
    var newUserButtonFadedOut = false
    
    //MARK: Outlets
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var errorMessageView: UIView!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var newUserButton: UIButton!
    @IBOutlet var usernameFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var loginRegisterButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var emailToUsernameVerticalConstraint: NSLayoutConstraint!

    @IBOutlet var loginRegisterButton: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!

    //MARK: Actions
    @IBAction func newUserButtonTapped(sender: UIButton) {
        setUpNewUserAnimation()
        usernameField.becomeFirstResponder()
    }
    
    @IBAction func loginRegisterButtonTapped(sender: UIButton) {
        resetErrorView()
        resignTextFields()
        var email: String?
        if let eMail = emailField?.text as String? {
            email = eMail
        }
        let password = passwordField.text
        let username = usernameField.text
        
        if !formValidator(username!, encryptedPassword: password!, email: email) {
            return
        }
        
        user = User(email: email, encryptedPassword: password!, username: username!, sessionToken: nil, userId: nil)
        initiateLoader()
        if newUserMode {
            apiRegistrationHandler()
        } else {
            apiLoginHandler()
        }
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        resignTextFields()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewControllerSetup()
        setKeyboardObservers()
    }
    
    
    //MARK: Helper functions
    
    func resetErrorView() {
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            self.errorMessageView.alpha = 0
            }, completion: { finished in
                self.errorMessageView.hidden = true
        })
    }
    
    /**
    Function makes API call and handles the response JSON and parses the user data and saves it in NSDefaults
    */
    func apiLoginHandler() {
        let helper = AuthAPIHelper()
        helper.userLogin(user, completion: { (results, error) -> Void in
            self.closeLoader()
            guard error == nil, let results = results as? NSDictionary else {
                self.displayAlertMessage("Sorry, unknown network error has occured, please try again. \n Error: \(error)", titleString: "Network Error")
                return
            }

            guard let statusString = results["status"] as? String where statusString == "successful",
            let userArray = results["user"] as? NSArray,
            let userInfo = userArray.firstObject as? NSDictionary,
            let userId = userInfo["userid"] as? Int,
                let sessionToken = userInfo["authentication_token"] as? String else {
                    
                    if let possibleError = results["message"] as? String
                    {
                        self.displayErrorString(possibleError)
                    } else {
                        self.displayErrorString("Unknown Error")
                    }
                    return
            }
            
            self.user.userId = userId
            self.user.sessionToken = sessionToken
            self.user.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    /**
    Resign textfields function
    */
    func resignTextFields() {
        if emailField.isFirstResponder() {
            emailField.resignFirstResponder()
        }
        if passwordField.isFirstResponder() {
            passwordField.resignFirstResponder()
        }
        if emailField.isFirstResponder() {
            emailField.resignFirstResponder()
        }
    }
    
    /**
    Function displays the error string and animates the view
    */
    
    func displayErrorString(errorString: String) {
        errorMessageView.hidden = false
        errorMessageLabel.text = errorString
        UIView.animateWithDuration(0.5, animations: {
            self.errorMessageView.alpha = 1
        })
    }

    
    /**
    Function makes the API call and handles the response JSON and parses the user data and saves it in NSDefaults
    */
    func apiRegistrationHandler() {
        let helper = AuthAPIHelper()
        helper.registerNewUser(user, completion: { (results, error) -> Void in
            self.closeLoader()
            guard error == nil, let results = results as? NSDictionary else {
                
                self.displayErrorString("Network Error")
                return
            }
            
            guard let statusString = results["status"] as? String where statusString == "successful",
                let userArray = results["user"] as? NSArray,
                let userInfo = userArray.firstObject as? NSDictionary,
                let userId = userInfo["userid"] as? Int,
                let sessionToken = userInfo["authentication_token"] as? String else {
                    
                    if let possibleError = results["message"] as? String
                    {
                        self.displayErrorString(possibleError)
                    } else {
                        self.displayErrorString("Unknown Error")
                    }
                    return
            }
            
            self.user.userId = userId
            self.user.sessionToken = sessionToken
            self.user.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    /**
    Function validates the fields. Username is optional since login does not require username, whereas new user sign up does.

    - Parameter username: the username string
    - Parameter encryptedPassword: the password
    - Parameter email: the email string
    
    - Returns: Bool
    */
    
    func formValidator(username: String, encryptedPassword: String, email: String?) -> Bool {
        if newUserMode {
            if email?.characters.count == 0 {
                displayErrorString("Email Missing")
                return false
            } else if !isValidEmail(email!) {
                displayErrorString("Invalid email")
                return false
            }
        }
        if encryptedPassword.characters.count == 0 {
            displayErrorString("Password Missing")
            return false
        } else if encryptedPassword.characters.count < 5 {
            displayErrorString("Password too short")
        }
        if username.characters.count == 0 {
            displayErrorString("Username Missing")
            return false
        }
        return true
    }
    
    /**
    Function uses regex to check for basic email format
    
    -Parameter email: String
    
    -Return: Bool
    */
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
    /**
    Function sets up the animation for the newUser button. Pops out the email field if new user mode is on
    */
    
    func setUpNewUserAnimation() {
        if !newUserMode {
            newUserButton.setTitle("CURRENT USERS", forState: .Normal)
            loginRegisterButton.setTitle("REGISTER", forState: .Normal)
            usernameFieldHeightConstraint.constant = 40
            emailToUsernameVerticalConstraint.constant = 16
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                self.newUserButton.backgroundColor = Colors.green
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            newUserButton.setTitle("SIGN UP", forState: .Normal)
            loginRegisterButton.setTitle("LOGIN", forState: .Normal)
            usernameFieldHeightConstraint.constant = 0
            emailToUsernameVerticalConstraint.constant = 0
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.newUserButton.backgroundColor = Colors.bluePurple
                }, completion: nil)
        }
        newUserMode = !newUserMode
    }

    func initialViewControllerSetup() {
        errorMessageView.layer.cornerRadius = 20
        errorMessageView.hidden = true
        errorMessageView.alpha = 0
        emailField.layer.cornerRadius = 5
        usernameField.layer.cornerRadius = 5
        passwordField.layer.cornerRadius = 5
        newUserButton.layer.cornerRadius = newUserButton.bounds.height/2
        usernameFieldHeightConstraint.constant = 0
        emailToUsernameVerticalConstraint.constant = 0
        renderButtonImageView(backButton, imageName: "header-back-button", color: Colors.redPurple)
    }
    
    /**
    NSNotification functions for keyboard animation to lift the continue button up the height of the keyboard.
    */
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !self.keyboardMoved {
                self.loginRegisterButtonBottomConstraint.constant += keyboardSize.height
                UIView.animateWithDuration(0.5) {
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
                
                self.loginRegisterButtonBottomConstraint.constant -= keyboardSize.height
                UIView.animateWithDuration(1.0) {
                    self.view.layoutIfNeeded()
                }
                self.keyboardMoved = false
                
            }
            
        }
    }
}

extension LoginRegistrationViewController: UITextFieldDelegate {
    /**
    Textfield delegate method. Checks if email and password fields are NOT empty. If NOT, then animate, if empty, then reset state.
    */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if !emailField.text!.isEmpty || !passwordField.text!.isEmpty || !usernameField!.text!.isEmpty {
            fadeOutNewUserButton()
        }
        return true
    }
    
    func fadeOutNewUserButton() {
        if !newUserButtonFadedOut {
            UIView.animateWithDuration(1.0, delay: 0, options: [], animations: {
                self.newUserButton.alpha = 0
                }, completion: { finished in
                    self.newUserButton.hidden = true
            })
            newUserButtonFadedOut = !newUserButtonFadedOut
        }
    }
}
