//
//  ParseAPIClient.swift
//  Planfit
//
//  Created by Estella Lai on 11/12/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit
import Parse

class ParseAPIClient : NSObject {
    
    // creates our instance
    class func createInstance() {
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "planfit"
                configuration.clientKey = nil  // set to nil assuming you have not set clientKey
                configuration.server = "https://planfit-codepath.herokuapp.com/parse"
            })
        )
    }
    
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
