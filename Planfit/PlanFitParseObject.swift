//
//  Protocol for all in app objects that will be saved to Parse Server
//  PlanFitParseObject.swift
//  Planfit
//
//  Created by Estella Lai on 11/12/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation
import Parse

protocol PlanFitParseObject {
    func writeToParse()
}
