//
//  Workout.swift
//  Planfit
//
//  Created by Harsh Trivedi on 11/14/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation

class Workout: NSObject, NSCoding {
    var uuid: String?
    var workoutName: String?
    var workoutDescription: String?
    var exercises : [String]?
    var totalDuration: Date?
    //again what are we using the count for?
    var count: Int?
    var id: String?
    var ownerName: String?
    var ownerAvatarURL: String?
    var createdAt:Date?
    var updatedAt:Date?
    
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
            let idValue = json["id"] as? String else {
            return nil
        }
        
        self.workoutDescription = workoutDescription
        self.uuid = idValue
        
        if let ownerJson = json["owner"] as? [String: Any] {
            self.ownerName = ownerJson["owner"] as? String
            self.ownerAvatarURL = ownerJson["avatar_url"] as? String
        }
        
        
        
        // Dates
        let dateFormatter = Workout.dateFormatter()
        if let dateString = json["created_at"] as? String {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json["updated_at"] as? String {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
    }
    
    // MARK: NSCoding
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uuid, forKey: "id")
        aCoder.encode(self.workoutDescription, forKey: "workoutDescription")
        aCoder.encode(self.ownerName, forKey: "ownerName")
        aCoder.encode(self.ownerAvatarURL, forKey: "ownerAvatarURL")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
        
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.uuid = aDecoder.decodeObject(forKey: "id") as? String
        self.workoutDescription = aDecoder.decodeObject(forKey: "workoutDescription") as? String
        self.ownerName = aDecoder.decodeObject(forKey: "ownerName") as? String
        self.ownerAvatarURL = aDecoder.decodeObject(forKey: "ownerAvatarURL") as? String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
    }
}
