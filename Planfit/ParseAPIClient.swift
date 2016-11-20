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

class ParseAPIClient {
    
    /**
     Singleton instance and private initializer
     
     */
    static let sharedInstance = ParseAPIClient()
    private init() {}
    
    /**
     Creates a Parse Instance to be used throughout session.
     
     - Parameter: None
     
     
     - Returns: None
     */
    func createInstance() {
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = APIClientConfig.PARSE_APP_ID
                configuration.clientKey = nil // set to nil assuming you have not set clientKey
                configuration.server = APIClientConfig.PARSE_SERVER
            })
        )
    }
    
    func loadCalendarForLoggedInUser(success: @escaping ([PFObject]?) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "PlannnedDay")
        query.whereKey("userUUID", equalTo: UUID()) // current User actual uuid instead of UUID()
        query.findObjectsInBackground { (results, error) in
            if let error = error {
                failure(error)
            } else {
                success(results)
            }
        }
    }
    
    /**
     Saves a Parse Object onto the Parse Server.
     
     - Parameter parseObject: Object to save onto Parse.
     - Parameter success: Success callback function.
     - Parameter failure: Failure callback function.
     
     
     - Returns: None
     */
    func save(parseObject : PFObject, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        parseObject.saveInBackground { (succeeded, error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    /**
     Retrieves a list of Parse Objects from the Parse Server.
     
     - Parameter className: Class belonging to object.
     - Parameter field: Name of field on which to query.
     - Parameter to: Value that equals to field.
     - Parameter success: Success callback function.
     - Parameter failure: Failure callback function.
     
     
     - Returns: None
     */
    func retrieveEquals(for className: String, on field: String, equal to: Any, success: @escaping ([PFObject]?) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: className)
        query.whereKey(field, equalTo: to)
        query.findObjectsInBackground { (results, error) in
            if let error = error {
                failure(error)
            } else {
                success(results)
            }
        }
    }
    
}
