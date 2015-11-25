//
//  ForumPostComment.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/23/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import MapKit

class ForumPostComment: NSObject {
    var id: Int?
    var forumId: Int?
    var posterId: Int?
    var posterUsername: String?
    var body: String!
    var createdAt: NSDate?
    var imageURL: String?
    var commentFlagged: Bool?
    var repliedToForumId: Int?
    var locationPinned: CLLocation?
    var attachedPhoto: UIImage?
    var userHasLiked: Int = 0
    var totalLikes: Int = 0
    var totalReplies: Int = 0
    var userHasFlagged: Bool = false
    
    init(body: String?) {
        self.body = body
    }
    
    //MARK: API Dictionary Builder
    func apiDictionaryBuilder() -> Dictionary<String, AnyObject> {
        var responseDictionary: [String: AnyObject] = [
            "body" : body,
        ]
        
        if let forumId = forumId {
            responseDictionary["forum_id"] = forumId 
        }
        
        if let locationPinned = locationPinned {
            responseDictionary["location_pin_latitude"] = locationPinned.coordinate.latitude
            responseDictionary["location_pin_longitude"] = locationPinned.coordinate.longitude
        }
        
        if let imageURL = imageURL {
            responseDictionary["image_url"] = imageURL
        }
        
        if let repliedToForumId = repliedToForumId {
            responseDictionary["replied_to_forum_id"] = repliedToForumId
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

