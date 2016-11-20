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
    
    static var allRoutines: [Routine] = []
    
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
            let idValue = json["id"] as? UUID else {
                return nil
        }
        
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
}
