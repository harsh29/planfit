//
//  ParseAPIClient.swift
//  API Client to handle persistence to Parse Server
//  Planfit
//
//  Created by Estella Lai on 11/12/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit
import Parse

class ParseAPIClient : NSObject {
    
    /**
     Creates a Parse Instance to be used throughout session.
     
     - Parameter: None
     
     
     - Returns: None
     */
    class func createInstance() {
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "planfit"
                configuration.clientKey = nil  // set to nil assuming you have not set clientKey
                configuration.server = "https://planfit-codepath.herokuapp.com/parse"
            })
        )
    }
    
    /**
     Saves a Parse Object onto the Parse Server.
     
     - Parameter parseObject: Object to save onto Parse.
     - Parameter success: Success callback function.
     - Parameter failure: Failure callback function.
     
     
     - Returns: None
     */
    class func save(parseObject : PFObject, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        parseObject.saveInBackground { (succeeded, error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
}
