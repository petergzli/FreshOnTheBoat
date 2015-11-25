//
//  ChangeLocationViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/14/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit

protocol ChangeLocationViewControllerDelegate {
    func closeChangeLocationViewController()
    func updateUserPreferences(userPreferenceFilter: UserPreferenceFilter)
}

class ChangeLocationViewController: UIViewController, KeyboardObserverType, CLLocationManagerDelegate {
    
    //MARK: Variables and constants
    var userPreferenceFilter = UserPreferenceFilter()
    var keyboardMoved = false
    var enterAddressFieldContainerViewIsHidden = false
    var delegate: ChangeLocationViewControllerDelegate?

    //MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var updateButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var currentButtonRadioButtonImage: UIImageView!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var enterAddressTextFieldContainerView: UIView!
    
    //MARK: Actions
    @IBAction func updateButtonTapped(sender: UIButton) {
        addressTextField.resignFirstResponder()
        validateCurrentPreferenceSelection()
    }
    
    @IBAction func currentLocationButtonTapped(sender: UIButton) {
        currentLocationButtonSelected()
    }
    
    @IBAction func currentLocationLabelButtonTapped(sender: UIButton) {
        currentLocationButtonSelected()
    }
    
    @IBAction func clearButtonTapped(sender: UIButton) {
        addressTextField.resignFirstResponder()
        delegate?.closeChangeLocationViewController()
    }
    
    //MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeImage()
        setKeyboardObservers()
        userPreferenceFilter.locationManager.delegate = self
    }

    
    //MARK: Helper functions
    
    /**
    Function is initiated when the current location button is selected
    */
    func currentLocationButtonSelected() {
        if userPreferenceFilter.checkForLocationPreference() {
            changeRadioButtonImage(currentButtonRadioButtonImage)
        } else {
            displayLocationAlert()
        }
    }
    
    /**
    Function animates the textfield and or label whenever the current location button is toggled
    */
    func animateTextFieldContainerView() {
        if userPreferenceFilter.currentLocationOn {
            addressTextField.resignFirstResponder()
        } else {
            addressTextField.becomeFirstResponder()
        }
    }
    
    

    /**
    Function sets up the view, checking if the current user exists or not
    */
    func initialSetUp() {
        if userPreferenceFilter.currentLocationOn && userPreferenceFilter.checkForLocationPreference() {
            userPreferenceFilter.getCurrentLocationCoordinates { () -> Void in
                self.getAddressStringFromCoordinates()
            }
            self.currentButtonRadioButtonImage.image = UIImage(named: "radio-button-checked")
            return
        } else {
            self.getAddressStringFromCoordinates()
            self.currentButtonRadioButtonImage.image = UIImage(named: "radio-button-clear")
        }
    }
    /**
    Initiates the images on the view to change the color by rendering
    */
    func initializeImage() {
        renderImageView(currentButtonRadioButtonImage, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.54))
        renderButtonImageView(clearButton, imageName: "cancel-button", color: Colors.mediumGrey)
    }
    
    /**
    Function is a reverse geocoder that grabs the current location based on user coordinates
    */
    func getAddressStringFromCoordinates() {
        let location = userPreferenceFilter.defaultLocation
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            guard error == nil, let initialLocation = (placemarks?.first as CLPlacemark?) else {
                self.addressTextField.text = "Location Unknown"
                return
            }
            self.addressTextField.text = initialLocation.locality
        })
    }
    
    /**
    Function validates the selection of the user, i.e. checks whether the current location choice should be selected or the address field (using geocoder)
    */
    func validateCurrentPreferenceSelection() {
        if userPreferenceFilter.currentLocationOn {
            userPreferenceFilter.getCurrentLocationCoordinates({ () -> Void in
                self.delegate?.updateUserPreferences(self.userPreferenceFilter)
            })
        } else {
            if addressTextField.text?.characters.count == 0 {
                return
            }
            getAddressFromTextField(addressTextField.text!)
        }
    }

    /**
    Function animates the radio button with a spring effect as well as changes the image to the on/off version
    
    */
    func changeRadioButtonImage(radioButtonImage: UIImageView) {
        if !userPreferenceFilter.currentLocationOn {
            radioButtonImage.image = UIImage(named: "radio-button-checked")
            radioButtonImage.transform = CGAffineTransformMakeScale(0.1, 0.1)
            UIView.animateWithDuration(0.50, delay: 0, usingSpringWithDamping: 0.20, initialSpringVelocity: 3.0, options: [UIViewAnimationOptions.AllowUserInteraction], animations: {
                radioButtonImage.transform = CGAffineTransformIdentity
                }, completion: nil)
            userPreferenceFilter.currentLocationOn = true
            addressTextField.text = nil
        } else {
            radioButtonImage.image = UIImage(named: "radio-button-clear")
            userPreferenceFilter.currentLocationOn = false
        }
        renderImageView(radioButtonImage, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.54))
        animateTextFieldContainerView()
    }
    
    /**
    NSNotification functions for keyboard animation to lift the continue button up the height of the keyboard.
    */
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !self.keyboardMoved {
                self.updateButtonBottomConstraint.constant += keyboardSize.height
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
                
                self.updateButtonBottomConstraint.constant -= keyboardSize.height
                UIView.animateWithDuration(1.0) {
                    self.view.layoutIfNeeded()
                }
                self.keyboardMoved = false
            }
        }
    }
    
    /**
    Function uses CLGeocoder to get the address from a string text. If error, then let user know address is not valid, else save address as coordinates in currentLocation
    
    -Parameter address: String text of the presumed address
    */
    
    func getAddressFromTextField(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            
            guard error == nil, let initialLocation = (placemarks?.first as CLPlacemark?)?.location as CLLocation? else {
                self.displayAlertMessage("Sorry, we seem to have trouble processing that location \n Error: \(error)", titleString: "Address Error")
                return
            }
            
            self.userPreferenceFilter.defaultLocation = initialLocation
            self.delegate?.updateUserPreferences(self.userPreferenceFilter)
        })
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
}

extension ChangeLocationViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        addressTextField.text = nil
//        animateTextFieldContainerView()
        currentButtonRadioButtonImage.image = UIImage(named: "radio-button-clear")
        userPreferenceFilter.currentLocationOn = false
    }
}
