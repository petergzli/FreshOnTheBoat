//
//  User.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/18/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import MapKit

let userKey = "UserKey"

class User: NSObject, NSCoding {
    
    var userId: Int?
    var username: String?
    var encryptedPassword: String!
    var email: String!
    var avatarName: String?
    var sessionToken: String?
    var defaultUserPreferences = UserPreferenceFilter()
    
    init(email: String?, encryptedPassword: String, username: String, sessionToken: String?, userId: Int?) {
        self.username               = username
        self.sessionToken           = sessionToken
        self.userId                 = userId
        self.email                  = email
        self.encryptedPassword      = encryptedPassword
    }
    
    
    //MARK: API Parameter builder
    func apiDictionaryBuilder(user: User) -> Dictionary<String, AnyObject> {
        var responseDictionary = [
            "username" : user.username,
            "encrypted_password" : user.encryptedPassword
        ]
        if let eMail = user.email as String? {
            responseDictionary["email"] = eMail
        }
        return responseDictionary
    }
    
    //MARK: NSCoder protocol functions
    
    @objc required init(coder aDecoder: NSCoder){
        //init()
        
        sessionToken            = aDecoder.decodeObjectForKey("sessionToken") as? String
        email                   = aDecoder.decodeObjectForKey("email") as! String
        userId                  = aDecoder.decodeObjectForKey("userId") as? Int
        username                = aDecoder.decodeObjectForKey("username") as? String
        encryptedPassword       = aDecoder.decodeObjectForKey("encryptedPassword") as! String
        
        if let defaultUserPrefers = aDecoder.decodeObjectForKey("defaultUserPreferences") as? UserPreferenceFilter {
            defaultUserPreferences = defaultUserPrefers
        }
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder){
        //encodeWithCoder(aCoder)
        
        aCoder.encodeObject(encryptedPassword, forKey: "encryptedPassword")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(username, forKey: "username")
        aCoder.encodeObject(userId, forKey: "userId")
        aCoder.encodeObject(sessionToken, forKey: "sessionToken")
        aCoder.encodeObject(defaultUserPreferences, forKey: "defaultUserPreferences")
    }
    
    //MARK: Helper Methods
    /**
    Function to save the User model state to NSUserDefaults
    */
    func save() {
        let encodedUser = NSKeyedArchiver.archivedDataWithRootObject(self)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(encodedUser, forKey: userKey)
        userDefaults.synchronize()
    }
    
    /**
    Function to log out user from NSUserDefaults
    */
    class func logout() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(userKey)
    }
    
    /**
    Function to retrieve the current stored user
    :returns: user The user nsobject that was stored in nsuserdefaults
    */
    class func currentUser() -> User? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let encodedUser: NSData? = defaults.objectForKey(userKey) as? NSData {
            
            if (encodedUser != nil) {
                return NSKeyedUnarchiver.unarchiveObjectWithData(encodedUser!) as? User
            }
        }
        
        return nil
    }
    
    class func isAuthenticated() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        return (defaults.objectForKey(userKey) != nil)
    }
}