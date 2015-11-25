//
//  PinLocationViewController.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/17/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit

protocol PinLocationViewControllerDelegate {
    func userHasPinnedLocation(chosenLocation: CLLocation)
}

class PinLocationViewController: UIViewController, KeyboardObserverType {

    //MARK: Variables and constants
    var delegate: PinLocationViewControllerDelegate?
    var userPreferenceFilter = UserPreferenceFilter()
    var keyboardMoved = false
    var chosenLocation: CLLocationCoordinate2D?
    var buttonAnimated = false
    
    //MARK: Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var pinLocationBottomConstraint: NSLayoutConstraint!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var locationPlacemark: UIImageView!
    
    //MARK: Actions
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        if addressTextField.text != "" {
            getAddressFromTextField(addressTextField.text!)
        }
    }
    
    @IBAction func pinLocationButtonTapped(sender: UIButton) {
        chosenLocation = mapView.centerCoordinate
        delegate?.userHasPinnedLocation(CLLocation(latitude: chosenLocation!.latitude, longitude: chosenLocation!.longitude))
        navigationController?.popViewControllerAnimated(true)
    }

    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardObservers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpMapViewInitialLocation()
        setUpNavigationController()
    }
    
    override func viewDidAppear(animated: Bool) {
        searchButtonWidthConstraint.constant = 0
        view.layoutIfNeeded()
    }

    //MARK: Helper functions
    /**
    Function sets up the initial mapView location
    */
    func setUpMapViewInitialLocation() {
        
        var initialLocation = CLLocation(latitude: 34.067124, longitude: -118.444792)
        
        if let currentUser = User.currentUser() {
            initialLocation = currentUser.defaultUserPreferences.defaultLocation
        }
        
        if userPreferenceFilter.checkForLocationPreference() {
            userPreferenceFilter.getCurrentLocationCoordinates({ () -> Void in
            })
        }
        
        initialLocation = userPreferenceFilter.defaultLocation
        let regionRadius: CLLocationDistance = 1000
        centerMapOnLocation(initialLocation, regionRadius: regionRadius)
        chosenLocation = mapView.centerCoordinate
    }
    
    /**
    Function sets up the navigation controller with the back button as well as a title
    */
    func setUpNavigationController() {
        let backButton = UIBarButtonItem(image: UIImage(named: "header-back-button"), style: .Plain, target: self, action: "backButtonTapped")
        
        backButton.title = ""
        if navigationController != nil {
            navigationItem.leftBarButtonItem = backButton
            navigationItem.title = "Pin a Location"
        }
        addRoundedCornersToUIButton(searchButton)
        renderImageView(locationPlacemark, color: Colors.redPurple)
    }
    
    /**
    Adds rounded corners to UIButton object.
    
    - Parameter button: UIButton
    */
    func addRoundedCornersToUIButton(button: UIButton) {
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 3
        button.layer.borderColor = Colors.redPurple.CGColor
    }
    
    /**
    Function dismisses the view controller, either with a navigation controller or a modal dismiss
    */
    func backButtonTapped() {
        self.addressTextField.resignFirstResponder()
        if navigationController != nil {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /**
    Method centers the mapView to the CLLocation coordinates with a regionRadius

    - Parameter location: CLLocation coordinates
    - Parameter regionRadius: CLLocationDistance radius
    */
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /**
    NSNotification functions for keyboard animation to lift the continue button up the height of the keyboard.
    */
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if !self.keyboardMoved {
                self.pinLocationBottomConstraint.constant += keyboardSize.height
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
                self.pinLocationBottomConstraint.constant -= keyboardSize.height
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
            self.addressTextField.resignFirstResponder()
            self.centerMapOnLocation(initialLocation, regionRadius: 1000)
        })
    }
}

extension PinLocationViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.addressTextField.resignFirstResponder()
    }
}