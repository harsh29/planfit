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

class ParseUserAPIClient {
    
    /**
     Singleton instance and private initializer
     
    */
    static let sharedInstance = ParseUserAPIClient()
    private init() {}
    
    /**
     Returns a current PFUser object, if it exists.
     
     - Returns: PFUser?
     */
    func getCurrentUser() -> PFUser? {
        return PFUser.current()
    }
    
    /**
     Signs up a user to Parse Server.
     
     - Parameter user:  The user in the current session.
     - Parameter success: Success callback function.
     - Parameter failure: Failure callback function.
     
     
     - Returns: None
     */
    func signUp(user: UserDataModel, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        if (getCurrentUser() == nil) {
            let parseUser = PFUser()
            parseUser.username = user.username
            parseUser.password = user.password
            parseUser.email = user.email
            
            parseUser.signUpInBackground { (succeeded, error) in
                if let error = error {
                    // Show the errorString somewhere and let the user try again.
                    failure(error)
                } else {
                    // Hooray! Let them use the app now.
                    success()
                }
            }
        }
    }
    
    /**
     Login for a user to Parse Server.
     
     - Parameter user:  The user in the current session.
     - Parameter success: Success callback function.
     - Parameter failure: Failure callback function.
     
     
     - Returns: None
     */
    func login(user: UserDataModel, success: @escaping (PFUser) -> (), failure: @escaping () -> ()) {
        do {
            let loggedInUser = try PFUser.logIn(withUsername: user.username, password: user.password)
            success(loggedInUser)
        } catch {
            failure()
        }
    }
}
