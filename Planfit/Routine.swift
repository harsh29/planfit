//
//  Routine.swift
//  Planfit
//
//  Created by Harsh Trivedi on 11/14/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation
import Parse

class Routine: NSObject, NSCoding {
    var routineUUID: UUID? // [Olya says:] in swift 3 NSUUID is just UUID.
    var routineName: String?
    var routineDescription: String?
    var exerciseIds : [UUID]? // [Olya says:] I stil think these should be actual exercise objects but since it's exercise ids I'm going to rename this var for what it is -- exerciseIds
    var totalDuration: Int?
    //again what are we using the count for?
    var count: Int?
    var id: String? // [Olya says:] what is this id for?
    var ownerName: String?
    var ownerAvatarURL: URL?
    var createdAt:Date?
    var updatedAt:Date?
    var userUUID: UUID!
    var exercises: [Exercise] = []
    var isCancelled: Bool! = false
    
    static var _allRoutines: [Routine] = []
    static var allRoutines: [Routine] = {
        
        if (_allRoutines.isEmpty) {
            _allRoutines = getRoutineSet()
        }
        return _allRoutines
    }()
    static let sharedDateFormatter = dateFormatter()
    
    class func dateFormatter() -> DateFormatter {
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        aDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
    
    required override init() {
    }
    
    required init?(json: [String: Any]) {
        guard let workoutDescription = json["description"] as? String,
            let idValue = json["id"] as? UUID,
            let workoutName = json["name"] as? String else {
                return nil
        }
        self.routineName = workoutName
        self.routineDescription = workoutDescription
        self.routineUUID = idValue
        
        if let ownerJson = json["owner"] as? [String: Any] {
            self.ownerName = ownerJson["owner"] as? String
            self.ownerAvatarURL = ownerJson["avatar_url"] as? URL
        }
        
        
        
        // Dates
        let dateFormatter = Routine.dateFormatter()
        if let dateString = json["created_at"] as? String {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json["updated_at"] as? String {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
    }
    
    // MARK: NSCoding
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.routineUUID, forKey: "routineUUID")
        aCoder.encode(self.routineDescription, forKey: "routineDescription")
        aCoder.encode(self.ownerName, forKey: "ownerName")
        aCoder.encode(self.ownerAvatarURL, forKey: "ownerAvatarURL")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
        
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.routineUUID = aDecoder.decodeObject(forKey: "routineUUID") as? UUID
        self.routineDescription = aDecoder.decodeObject(forKey: "routineDescription") as? String
        self.ownerName = aDecoder.decodeObject(forKey: "ownerName") as? String
        self.ownerAvatarURL = aDecoder.decodeObject(forKey: "ownerAvatarURL") as? URL
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
    }
    
    init(routine: PFObject) {
        /// Not Implemented
        self.routineUUID = routine.value(forKey: "routineUUID") as? UUID
        
    }
    
    class func routinesWithArray(pfObjects: [PFObject]) -> [Routine] {
        var routines = [Routine]()
        
        for pfObject in pfObjects {
            let routine = Routine(routine: pfObject)
            routines.append(routine)
        }
        
        return routines
    }
    
    /// call this method to load user's routines when user logs in
    public class func loadRoutines() {
        
        ParseAPIClient.sharedInstance.loadForLoggedInUser(entity: "Routine", success: { (results: [PFObject]?) in
            let routines = Routine.routinesWithArray(pfObjects: results!)
            self.allRoutines = routines
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        
    }
    
    class func getExerciseSet(count: Int) -> [Exercise] {
        
        // TO DO: get exercises for this routine from Parse using exercise ids
        
        var exercises = [Exercise]()
        
        // temp exercise set
        for i in 0..<count {
            let exercise  = Exercise(name: "Exercise \(i)", description: "Exercise \(i) description.", duration: 5, reps: 10, imageURL: nil, image: nil, videoURL: nil)
            exercises.append(exercise)
        }
        return exercises
    }
    
    class func getRoutineSet() -> [Routine] {
        
        // TO DO: get all routines for this user from Parse
        
        var routines = [Routine]()
        
        // temp routine set
        let routine0 = Routine(json: ["name" : "Cardio Blast",
                                    "description" : "Lots of exercises to get your heart rate up.",
                                    "id" : UUID.init(uuidString: "e06a08e0-0687-4f33-8870-e64113b6f68a") as Any,
                                    "owner" : ["owner" : "minnie", "avatar_url" : "https://scontent.xx.fbcdn.net/v/t1.0-1/c0.2.50.50/p50x50/13709755_10201927466626271_4964123079867840378_n.jpg?oh=613ff325f2fd88bedf5e24f0de10b028&oe=58B5EA5B"]])
        routine0?.exerciseIds = [UUID.init(uuidString: "f48aa5c5-b67b-4f2e-b05b-f7d46de3986b")!,
                                    UUID.init(uuidString: "894391ab-80ca-4ae9-b102-c457291d5b84")!,
                                    UUID.init(uuidString: "a4ff15ab-8d93-4683-9b57-ce79751c94d9")!]
        routine0?.exercises = getExerciseSet(count: 3)
        
        let routine1 = Routine(json: ["name" : "Nowhere To Run",
                                      "description" : "Lots of leg exercises.",
                                      "id" : UUID.init(uuidString: "e06a08e0-0687-4f33-8870-e64113b6f68b") as Any,
                                      "owner" : ["owner" : "minnie", "avatar_url" : "https://scontent.xx.fbcdn.net/v/t1.0-1/c0.2.50.50/p50x50/13709755_10201927466626271_4964123079867840378_n.jpg?oh=613ff325f2fd88bedf5e24f0de10b028&oe=58B5EA5B"]])
        routine1?.exerciseIds = [UUID.init(uuidString: "f48aa5c5-b67b-4f2e-b05b-f7d46de3986c")!,
                                       UUID.init(uuidString: "894391ab-80ca-4ae9-b102-c457291d5b85")!,
                                       UUID.init(uuidString: "a4ff15ab-8d93-4683-9b57-ce79751c94d8")!]
        routine1?.exercises = getExerciseSet(count: 3)
        
        let routine2 = Routine(json: ["name" : "Sudden Death",
                                      "description" : "Crossfit exercise set.",
                                      "id" : UUID.init(uuidString: "e06a08e0-0687-4f33-8870-e64113b6f68c") as Any,
                                      "owner" : ["owner" : "minnie", "avatar_url" : "https://scontent.xx.fbcdn.net/v/t1.0-1/c0.2.50.50/p50x50/13709755_10201927466626271_4964123079867840378_n.jpg?oh=613ff325f2fd88bedf5e24f0de10b028&oe=58B5EA5B"]])
        routine2?.exerciseIds = [UUID.init(uuidString: "f48aa5c5-b67b-4f2e-b05b-f7d46de3986d")!,
                                       UUID.init(uuidString: "894391ab-80ca-4ae9-b102-c457291d5b86")!,
                                       UUID.init(uuidString: "a4ff15ab-8d93-4683-9b57-ce79751c94d7")!]
        routine2?.exercises = getExerciseSet(count: 3)
        
        routines.append(routine0!)
        routines.append(routine1!)
        routines.append(routine2!)
        return routines
    }
}
