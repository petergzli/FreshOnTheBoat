//
//  ForumAPI.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/20/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import Alamofire

class ForumAPIHelper {
    
    func postForumLike(like: Int, user: User, forumPostId: Int, usePassword: Bool = false, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        var parameters: [String: AnyObject] = ["forum_profile_id": forumPostId]
        
        if like > 0 {
            parameters["likes"] = like
        } else {
            parameters["dislikes"] = like
        }
        
        var plainString = "\(user.sessionToken!):" as NSString
        if usePassword {
            plainString = "\(user.username!):\(user.encryptedPassword)"
        }
        
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let header = ["Authorization": "Basic " + base64String!]
        
        Alamofire.request(.POST, Globals.baseURL + "forum/likes/", parameters: parameters, encoding: .JSON, headers: header)
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
    
    func postForumFlag(user: User, forumPostId: Int, usePassword: Bool = true, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        let parameters: [String: AnyObject] = ["forum_profile_flagged_id": forumPostId]

        var plainString = "\(user.sessionToken!):" as NSString
        if usePassword {
            plainString = "\(user.username!):\(user.encryptedPassword)"
        }
        
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let header = ["Authorization": "Basic " + base64String!]
        
        Alamofire.request(.POST, Globals.baseURL + "forum/flag/", parameters: parameters, encoding: .JSON, headers: header)
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
    
    
    func postForumCommentLike(like: Int, user: User, forumCommentPostId: Int, usePassword: Bool = false, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        var parameters: [String: AnyObject] = ["forum_profile_posting_id": forumCommentPostId]
        
        if like > 0 {
            parameters["likes"] = like
        } else {
            parameters["dislikes"] = like
        }
        
        var plainString = "\(user.sessionToken!):" as NSString
        if usePassword {
            plainString = "\(user.username!):\(user.encryptedPassword)"
        }
        
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let header = ["Authorization": "Basic " + base64String!]
        
        Alamofire.request(.POST, Globals.baseURL + "forum/comments/likes/", parameters: parameters, encoding: .JSON, headers: header)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    if let responseJSON = JSON as? NSDictionary  {
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
    
    func postNewForumComment(user: User, forumPostComment: ForumPostComment, usePassword: Bool = false, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        let parameters = forumPostComment.apiDictionaryBuilder()
        
        var plainString = "\(user.sessionToken!):" as NSString
        if usePassword {
            plainString = "\(user.username!):\(user.encryptedPassword)"
        }
        
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let header = ["Authorization": "Basic " + base64String!]
        
        Alamofire.request(.POST, Globals.baseURL + "forum/comments/newpost/", parameters: parameters, encoding: .JSON, headers: header)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    if let responseJSON = JSON as? NSDictionary{
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
    
    func getForumComments(forumId: Int, repliedToForumId: Int?, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        var parameters: [String: AnyObject] = ["forum_id": forumId]
        
        if let unwrappedRepliedToForumid = repliedToForumId {
            parameters = ["replied_to_forum_id": unwrappedRepliedToForumid]
        }
        
        if let currentUser = User.currentUser() {
            parameters["user_id"] = currentUser.userId!
        }
        
        Alamofire.request(.GET, Globals.baseURL + "forum/comments/getcomments/", parameters: parameters)
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
    
    func getAccountForumPostings(userId: Int, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        let parameters = ["user_id": userId]
        
        Alamofire.request(.GET, Globals.baseURL + "users/forumposts/", parameters: parameters)
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
    
    
    func getForumPostings(userPreferenceFilter: UserPreferenceFilter, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        let parameters: [String: AnyObject] = userPreferenceFilter.apiDictionaryBuilder()
        
        Alamofire.request(.GET, Globals.baseURL + "forum/getresults/", parameters: parameters)
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
    
    func postNewForumPost(user: User, forumPost: ForumPost, usePassword: Bool = false, completion : (results: AnyObject?, error: NSError?) -> Void) {
        
        let parameters = forumPost.apiDictionaryBuilder()
        
        var plainString = "\(user.sessionToken!):" as NSString
        if usePassword {
            plainString = "\(user.username!):\(user.encryptedPassword)"
        }
        
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let header = ["Authorization": "Basic " + base64String!]
        
        Alamofire.request(.POST, Globals.baseURL + "forum/newpost/", parameters: parameters, encoding: .JSON, headers: header)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    if let responseJSON = JSON as? NSDictionary{
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