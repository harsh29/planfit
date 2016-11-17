//
//  Exercise.swift
//  Planfit
//
//  Created by Harsh Trivedi on 11/14/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation
class Exercise: NSObject {
    var exerciseUUID: NSUUID?
    var exerciseName: String?
    var exerciseDescription: String?
    var previousExerciseName : [String]?
    var nextExerciseName : [String]?
    var exerciseDuration: Int?
    var reps: Int?
    var totalSets: Int?
    var currentSet: Int?
    var currentSetWeight: Int?
    var exerciseImageURL: URL?
    var exerciseVideoURL: URL?
    var createdAt:Date?
    var updatedAt:Date?
    
}
