//
//  AuthAPI.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/18/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import Alamofire

class AuthAPIHelper {
    
    func registerNewUser(user: User, completion : (results: AnyObject?, error: NSError?) -> Void) {

        let parameters = user.apiDictionaryBuilder(user)
        
        Alamofire.request(.POST, Globals.baseURL + "users/new/", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    if let responseJSON = JSON as? NSDictionary where responseJSON["status"] != nil {
                        completion(results: responseJSON, error: nil)
                    } else {
                        completion(results: nil, error: nil)
                    }
                case .Failure:
                    if let dataCompletion = response.data {
                        completion(results: dataCompletion, error: nil)
                    } else {
                        completion(results: nil, error: nil)
                    }
                }
            }
    }
    
    func userLogin(user: User, completion : (results: AnyObject?, error: NSError?) -> Void) {
        let parameters = user.apiDictionaryBuilder(user)
        
        let plainString = "\(user.username!):\(user.encryptedPassword!)" as NSString
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let header = ["Authorization": "Basic " + base64String!]

        Alamofire.request(.POST, Globals.baseURL + "users/login/", parameters: parameters, encoding: .JSON, headers: header)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    if let responseJSON = JSON as? NSDictionary {
                        completion(results: responseJSON, error: nil)
                    } else {
                        completion(results: nil, error: nil)
                    }
                case .Failure:
                    if let dataCompletion = response.data {
                        completion(results: dataCompletion, error: nil)
                    } else {
                        completion(results: nil, error: nil)
                    }
                }
        }
    }
}