//
//  User.swift
//  Planfit
//
//  Created by Harsh Trivedi on 11/14/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation

// Represents a user.
class User: NSObject, NSCoding
{
    var userUUID: NSUUID?
    var name: String?
    var screenName: String?
    var profileImageUrl: URL?
    
    var username: String!
    var password: String!
    var email: String!
    
    //i am using dictionary  here, if everyone prefers a dictionary we can change everyone to dictionary, i prefer the approch in Routine class using alamofire, i will let all of us make a call together.
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let profileImageUrlString =
            dictionary["profile_image_url"] as? String
        {
            // Get a larger image than what is provided by default.
            let profileImageUrlString =
                profileImageUrlString.replacingOccurrences(of: "_normal", with: "")
            
            profileImageUrl = URL(string: profileImageUrlString)
        }
        else
        {
            profileImageUrl = nil
        }
                
    }
    
    // Decodes User object using NSCoder.
    required init(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(
            forKey: "name") as? String
        screenName = aDecoder.decodeObject(
            forKey: "screen_name") as? String
        profileImageUrl = aDecoder.decodeObject(
            forKey: "profile_image_url") as? URL
            }
    
    // Encodes User object using NSCoder.
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(screenName, forKey: "screen_name")
        aCoder.encode(profileImageUrl, forKey: "profile_image_url")
    }
}
