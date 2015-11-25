//
//  UserPreferenceFilter.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/20/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

enum SearchFilter: Int {
    case Hottest    = 0
    case Newest     = 1
    case Top        = 2
}

class UserPreferenceFilter: NSObject, NSCoding {
    var locationManager = CLLocationManager()
    var defaultLocation: CLLocation = CLLocation(latitude: Double(34.067124), longitude: Double(-118.444792))
    var searchFilter: SearchFilter = .Hottest
    var category: Category = .General
    var currentLocationOn = false
    var defaultRadius: Int = 25
    var locationAuthorized = false
    
    override init() {
        
    }
    //MARK: JSON Dictionary builder
    
    func apiDictionaryBuilder() -> Dictionary<String, AnyObject> {
        var requestDictionary: [String: AnyObject] = [
            "latitude"  : defaultLocation.coordinate.latitude,
            "longitude" : defaultLocation.coordinate.longitude,
            "radius"    : defaultRadius,
            "category"  : category.rawValue,
            "preference": searchFilter.rawValue
        ]
        
        if let currentUser = User.currentUser() {
            requestDictionary["user_id"] = currentUser.userId!
        }
        
        return requestDictionary
    }
    
    //MARK: NSCoder protocol functions
    
    required init(coder aDecoder: NSCoder){
        //init()
        defaultLocation      = aDecoder.decodeObjectForKey("defaultLocation") as! CLLocation
        searchFilter         = SearchFilter.init(rawValue: aDecoder.decodeObjectForKey("searchFilter") as! Int)!
        defaultRadius        = aDecoder.decodeObjectForKey("defaultRadius") as! Int
        locationAuthorized = aDecoder.decodeObjectForKey("locationAuthorized") as! Bool
        currentLocationOn = aDecoder.decodeObjectForKey("currentLocationOn") as! Bool
        
        if let categoryRaw = aDecoder.decodeObjectForKey("category") as? Int {
            category = Category(rawValue: categoryRaw)!
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        //encodeWithCoder(aCoder)
        aCoder.encodeObject(defaultLocation, forKey: "defaultLocation")
        aCoder.encodeObject(searchFilter.rawValue, forKey: "searchFilter")
        aCoder.encodeObject(defaultRadius, forKey: "defaultRadius")
        aCoder.encodeObject(locationAuthorized, forKey: "locationAuthorized")
        aCoder.encodeObject(currentLocationOn, forKey: "currentLocationOn")
        aCoder.encodeObject(category.rawValue, forKey: "category")
    }
    
    func getCurrentLocationCoordinates(completion:()->Void) {
        
        guard checkForLocationPreference() else {
            completion()
            return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        defaultLocation = CLLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        completion()
    }
    
    func checkForLocationPreference() -> Bool {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationAuthorized = true
            return true
        } else {
            locationAuthorized = false
            return false
        }
    }
}


