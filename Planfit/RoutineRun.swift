//
//  RoutineRun.swift
//  Planfit
//
//  Created by Harsh Trivedi on 11/14/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation

enum Status {
    case Planned
    case Paused
    case Completed
    case InProgress
    case Cancelled
    
    //cannot think of methods that we will need here.
    
    //add a method to parse the string and return enum.
}

class RoutineRun: NSObject, NSCoding {
    var routine: Routine!
    var routineRunUUID: NSUUID?
    var routinePerformed: String?
    var routinePerformeduuid: NSUUID?
    //var status: Status
    var startedAt:Date?
    var completedAt:Date?
    
    //this will need to go into its own seperate class. creating a group of helper classes.
    //will move it, when i create that.
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
            guard let idValue = json["routineRunUUID"] as? NSUUID else {
                return nil
        }
        
        self.routineRunUUID = idValue
        
        
        //should we just save the routineUUID in here, and then make a second call to get the routine name and then fetch it if user wants to go into detail. if we want to show how many exercises were completed and how many were kept pending.
        guard let routineName = json["routine_performed"] as? String else {
            return nil
        }
        
        self.routinePerformed = routineName
        
        guard let routineuuid = json["routine_performed_uuid"] as? NSUUID else {
            return nil
        }
        self.routinePerformeduuid = routineuuid
        
        // Dates
        let dateFormatter = RoutineRun.dateFormatter()
        if let dateString = json["started_at"] as? String {
            self.startedAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json["completed_at"] as? String {
            self.completedAt = dateFormatter.date(from: dateString)
        }
        
        //Status
        //Again: is it status per exercise or all the exercises.
        //And master status
        /*
        if let routineRunStatus = json["status"] as? String {
           self.status =  Status.Completed
        }*/
    }
    
    //Add methods here to initialize a new Routine Run
    
    // MARK: NSCoding
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.routineRunUUID, forKey: "routineRunUUID")
        aCoder.encode(self.routinePerformed, forKey: "routinePerformed")
        aCoder.encode(self.routinePerformeduuid, forKey: "routinePerformeduuid")
       // aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.startedAt, forKey: "startedAt")
        aCoder.encode(self.completedAt, forKey: "completedAt")
        
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.routineRunUUID = aDecoder.decodeObject(forKey: "routineRunUUID") as? NSUUID
        self.routinePerformed = aDecoder.decodeObject(forKey: "routinePerformed") as? String
        self.routinePerformeduuid = aDecoder.decodeObject(forKey: "routinePerformeduuid") as? NSUUID
       // self.status = (aDecoder.decodeObject(forKey: "status") as? Status)!
        self.startedAt = aDecoder.decodeObject(forKey: "startedAt") as? Date
        self.completedAt = aDecoder.decodeObject(forKey: "completedAt") as? Date
    }
}


