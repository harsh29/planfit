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
import SwiftGifOrigin

class Calendar: NSObject{
    
    /// When user plans a routine for a calendar day,
    /// a new PlannedDay obj is created with user uuid, date and Routine obj
    /// and added to this array of plannedDays
    /// This property is initially populated from the API
    /// for logged in user.
    public static var plannedDays: [PlannedDay] = []
    private static var firstRun = true

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
        if(firstRun){
        self.plannedDays.append(self.getTempPlannedDay())
        }
        if let routine = self.dateRoutines[date] {
            return routine
        }
        
        return nil
    }
    
    /// dummy PlannedDay for testing while Calendar screen is under construction
    public class func getTempPlannedDay() -> PlannedDay {
        
        let routine = Routine()
        routine.routineName = "My Favorite Routine"
        routine.routineDescription = "I run 24 miles today in San Diego then do some pushups then watch Maru on YouTube."
        routine.exercises = getTempSteps()
        
        let plannedDay = PlannedDay()
        plannedDay.date = Date()
        plannedDay.routine = routine
        
        return plannedDay
    }
    
    public class func getAllPlannedWorkouts() ->[PlannedDay] {
        
        let routines = Routine.getRoutineSet();
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if(firstRun){
        var someDateTime = formatter.date(from: "2016/12/08")
        let plannedDay = PlannedDay()
        plannedDay.date = someDateTime
        plannedDay.routine = routines[0]
        plannedDays.append(plannedDay)
        
        someDateTime = formatter.date(from: "2016/12/09")
        let plannedDay1 = PlannedDay()
        plannedDay1.date = someDateTime
        plannedDay1.routine = routines[1]
        plannedDays.append(plannedDay1)
        
        someDateTime = formatter.date(from: "2016/12/11")
        let plannedDay2 = PlannedDay()
        plannedDay2.date = someDateTime
        plannedDay2.routine = routines[2]
        plannedDays.append(plannedDay2)
        
        someDateTime = formatter.date(from: "2016/12/15")
        let plannedDay3 = PlannedDay()
        plannedDay3.date = someDateTime
        plannedDay3.routine = routines[0]
        plannedDays.append(plannedDay3)
        
        someDateTime = formatter.date(from: "2016/12/18")
        let plannedDay4 = PlannedDay()
        plannedDay4.date = someDateTime
        plannedDay4.routine = routines[1]
        plannedDays.append(plannedDay4)
        
        someDateTime = formatter.date(from: "2016/12/22")
        let plannedDay5 = PlannedDay()
        plannedDay5.date = someDateTime
        plannedDay5.routine = routines[2]
        plannedDays.append(plannedDay5)
        firstRun = false
        }
        return plannedDays
    }
    
    // return some dummy steps for testing while routine detail screen is under construction
    private class func getTempSteps() -> [Exercise] {
        
        let step0 = Exercise(name: "Run", description: "My regular treadmill run", duration: 5, reps: nil, imageURL: "https://goo.gl/0Qhlhp", image: #imageLiteral(resourceName: "run"), videoURL: nil)
        let step1 = Exercise(name: "Pushup", description: "Chest, shoulders, arms", duration: 5, reps: nil, imageURL: "https://goo.gl/73nGJB", image: #imageLiteral(resourceName: "pushup"), videoURL: nil)
        let gif = UIImage.gif(name: "maru")
        let step2 = Exercise(name: "Maru Swings", description: "Just swinging", duration: 5, reps: nil, imageURL: nil, image: gif, videoURL: "https://youtu.be/rnj6cnlIjM4?t=170")
        let steps = [step0, step1, step2]
        
        return steps
    }
    
}
