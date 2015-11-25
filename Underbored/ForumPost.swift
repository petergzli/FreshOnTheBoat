//
//  ForumPost.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/17/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import MapKit

enum Category: Int {
    case Food = 0
    case Shopping = 1
    case Entertainment = 2
    case General = 3
}

class ForumPost: NSObject {
    
    var forumId: Int?
    var forumOriginalUser: String?
    var title: String!
    var imageURL: String?
    var locationPinned: CLLocation?
    var attachedPhoto: UIImage?
    var userHasLiked: Int = 0
    var userHasFlagged: Bool = false
    var totalLikes: Int = 0
    var totalComments: Int = 0
    var postLocation: CLLocation!
    var forumDescription: String?
    var category: Int?
    var createdBy: String?
    var createdById: Int?
    
    init(title: String!, postLocation: CLLocation!) {
        self.title               = title
        self.postLocation        = postLocation
    }
    
    //MARK: API Dictionary Builder
    func apiDictionaryBuilder() -> Dictionary<String, AnyObject> {
        var responseDictionary: [String: AnyObject] = [
            "title" : title,
            "latitude" : postLocation.coordinate.latitude,
            "longitude": postLocation.coordinate.longitude
        ]
        
        if let category = category as Int? {
            responseDictionary["category"] = category
        }
        
        if let imageURL = imageURL as String? {
            responseDictionary["image_url"] = imageURL
        }
        
        if let locationPinned = locationPinned as CLLocation? {
            responseDictionary["location_pin_latitude"] = locationPinned.coordinate.latitude
            responseDictionary["location_pin_longitude"] = locationPinned.coordinate.longitude
        }
        
        if let forumDescription = forumDescription as String? {
            responseDictionary["description"] = forumDescription
        }
        
        return responseDictionary
    }
    
    func imageNSURL() -> NSURL?
    {
        let amazonURL = Globals.amazonURL
        let imageFullPath = amazonURL + imageURL!
        return NSURL(string: imageFullPath)
    }
}

