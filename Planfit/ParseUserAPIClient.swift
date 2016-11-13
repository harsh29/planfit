//
//  ParseUserAPIClient.swift
//  Client for handling login and signing up via Parse
//  Planfit
//
//  Created by Estella Lai on 11/12/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit
import Parse

class ParseUserAPIClient: NSObject {
    
    class func getCurrentUser() -> PFUser? {
        return PFUser.current()
    }
    
    class func signUp(user: User, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        if (getCurrentUser() == nil) {
            let parseUser = PFUser()
            parseUser.username = user.username
            parseUser.password = user.password
            parseUser.email = user.email
            
            parseUser.signUpInBackground { (succeeded, error) in
                if let error = error {
                    // Show the errorString somewhere and let the user try again.
                    NSLog(error.localizedDescription)
                    failure(error)
                } else {
                    // Hooray! Let them use the app now.
                    success()
                }
            }
        }
    }
    
    class func login(user: User, success: @escaping (PFUser) -> (), failure: @escaping () -> ()) {
        do {
            let loggedInUser = try PFUser.logIn(withUsername: user.username, password: user.password)
            success(loggedInUser)
        } catch {
            NSLog("Can't sign user \(user.username) in")
            failure()
        }
    }
}
