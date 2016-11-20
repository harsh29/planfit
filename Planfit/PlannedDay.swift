//
//  PlannedDay.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/19/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation
import Parse

class PlannedDay: NSObject {
    
    var userUUID: UUID!
    var date: Date!
    var routine: Routine!
    
    override init(){}
    
    init(plannedDay: PFObject) {
        self.userUUID = plannedDay.value(forKey: "userUUID") as! UUID
        //self.date = plannedDay.value(forKey: "date") as! Date
        //self.routine = plannedDay.value(forKey: "routine") as! Routine
        
    }
    
    class func plannedDaysWithArray(pfObjects: [PFObject]) -> [PlannedDay] {
        var plannedDays = [PlannedDay]()
        
        for pfObject in pfObjects {
            let plannedDay = PlannedDay(plannedDay: pfObject)
            plannedDays.append(plannedDay)
        }
        
        return plannedDays
    }
}
