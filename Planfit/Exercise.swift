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
    var exerciseDuration: Int?
    var reps: Int?
    var totalSets: Int?
    var currentSet: Int?
    var currentSetWeight: Int?
    var exerciseImageURL: URL?
    var exerciseVideoURL: URL?
    var createdAt:Date?
    var updatedAt:Date?
    
    init(name: String?, description: String?, duration: Int?, reps: Int?, imageURL: String?, videoURL: String?) {
        if let eName = name {
            self.exerciseName = eName
        }
        if let eDescription = description {
            self.exerciseDescription = eDescription
        }
        if let eDuration = duration {
            self.exerciseDuration = eDuration
        }
        if let eReps = reps {
            self.reps = eReps
        }
        if let eImageURL = imageURL {
            self.exerciseImageURL = URL(string: eImageURL)
        }
        if let eVideoURL = videoURL {
            self.exerciseVideoURL = URL(string: eVideoURL)
        }
        self.createdAt = Date()
        
        //TO DO
        //write to Parse, update id.
        
    }
    
}
