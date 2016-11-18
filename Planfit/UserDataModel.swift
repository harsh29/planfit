//  Example User Model class for PlanFit
//  User.swift
//  Planfit
//
//  Created by Estella Lai on 11/12/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit
import Parse

class UserDataModel: PlanFitParseObject {
    static let _className = "User"
    var username: String
    var password : String
    var email: String
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
    
    required init(parseObject: PFObject) {
        self.username = parseObject["username"] as! String
        self.password = ""
        self.email = parseObject["email"] as! String
    }
    
    func writeToParse() {
        let userObject = PFObject(className: UserDataModel._className)
        userObject["username"] = self.username
        userObject["password"] = self.password
        userObject["email"] = self.email
        ParseAPIClient.sharedInstance.save(parseObject: userObject, success: {
            NSLog("User object with userame \(self.username) saved successfully.")
            }, failure: {(error) in
                NSLog(error.localizedDescription)
        })
    }
    
}
