//
//  Exercise.swift
//  Planfit
//
//  Created by Harsh Trivedi on 11/14/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation
class Exercise: NSObject {
    var exerciseuuid: String?
    var exerciseName: String?
    var exerciseDescription: String?
    var previousExerciseName : [String]?
    var nextExerciseName : [String]?
    var exerciseDuration: Date?
    var reps: Int?
    var totalSets: Int?
    var currentSet: Int?
    var currentSetWeight: Int?
    var exerciseImageURL: String?
    var exerciseVideoURL: String?
    var createdAt:Date?
    var updatedAt:Date?
    
}
