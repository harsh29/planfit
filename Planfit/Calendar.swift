//
//  Calendar.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/19/16.
//  Copyright © 2016 Planfit. All rights reserved.
//
import UIKit
import Foundation
import Parse


class Calendar: NSObject{
    
    /// When user plans a routine for a calendar day,
    /// a new PlannedDay obj is created with user uuid, date and Routine obj
    /// and added to this array of plannedDays
    /// This property is initially populated from the API
    /// for logged in user.
    static var plannedDays: [PlannedDay] = []
    
    /// computed dictionary of planned date strings to routines
    static var dateRoutines: [String: Routine] = {
        
        var computedDateRoutines = [String: Routine] ()
        for day in Calendar.plannedDays {
            let date = formatter.string(from: day.date)
            let routine = day.routine
            
            computedDateRoutines[date] = routine
        }
        return computedDateRoutines
    }()
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    /// call this method to load user's calendar when user logs in
    public class func loadCalendar() {

        ParseAPIClient.sharedInstance.loadForLoggedInUser(entity: "PlannedDay", success: { (results: [PFObject]?) in
            let days = PlannedDay.plannedDaysWithArray(pfObjects: results!)
            self.plannedDays = days
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        
    }
    
    public class func getTodaysRoutine() -> Routine? {
        
        let date = formatter.string(from: Date())
        /// add a dummy routine for testing while Calendar screen is under construction
        self.plannedDays.append(self.getTempPlannedDay())
        
        if let routine = self.dateRoutines[date] {
            return routine
        }
        
        return nil
    }
    
    /// dummy PlannedDay for testing while Calendar screen is under construction
    private class func getTempPlannedDay() -> PlannedDay {
        
        let routine = Routine()
        routine.routineName = "MARATHON DAY"
        routine.routineDescription = "I run 24 miles today in San Diego"
        
        let plannedDay = PlannedDay()
        plannedDay.date = Date()
        plannedDay.routine = routine
        
        return plannedDay
    }
    
}
