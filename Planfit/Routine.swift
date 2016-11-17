//
//  Routine.swift
//  Planfit
//
//  Created by Harsh Trivedi on 11/14/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation

class Routine: NSObject, NSCoding {
    var routineUUID: NSUUID?
    var routineName: String?
    var routineDescription: String?
    var exercises : [NSUUID]?
    var totalDuration: Int?
    //again what are we using the count for?
    var count: Int?
    var id: String?
    var ownerName: String?
    var ownerAvatarURL: URL?
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
            let idValue = json["id"] as? NSUUID else {
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
        self.routineUUID = aDecoder.decodeObject(forKey: "routineUUID") as? NSUUID
        self.routineDescription = aDecoder.decodeObject(forKey: "routineDescription") as? String
        self.ownerName = aDecoder.decodeObject(forKey: "ownerName") as? String
        self.ownerAvatarURL = aDecoder.decodeObject(forKey: "ownerAvatarURL") as? URL
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
    }
}
