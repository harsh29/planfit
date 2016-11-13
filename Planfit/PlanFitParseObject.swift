//
//  PlanFitParseObject.swift
//  Protocol for all in app objects that will be saved to Parse Server
//  Planfit
//
//  Created by Estella Lai on 11/12/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation
import Parse

protocol PlanFitParseObject {
    
    /**
     Saves object onto Parse.
     
     - Parameter: None
     
     
     - Returns: None
     */
    func writeToParse()
}
