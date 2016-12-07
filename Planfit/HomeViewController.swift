//
//  HomeViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tabButton: UITabBarItem!
    @IBOutlet weak var routineStartView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var todaysRoutine: Routine?
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.loadUserState()
        self.setCalendarCardAppearance()
        self.setCalendarCardContent()
    }
    
    private func setCalendarCardAppearance() {
        
        routineStartView.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        routineStartView.layer.shadowRadius = 2.0
        routineStartView.layer.shadowOpacity = 0.5
        routineStartView.layer.masksToBounds = false
        
        routineStartView.layer.borderColor = UIColor.black.cgColor
        routineStartView.layer.borderWidth = 1
    }
    
    private func setCalendarCardContent() {
        
        let date = HomeViewController.formatter.string(from: Date())
        self.dateLabel.text = date
        
        if let routine = Calendar.getTodaysRoutine() {
            todaysRoutine = routine
            self.startButton.isHidden = false
            self.routineNameLabel.text = routine.routineName
        } else {
            self.startButton.isHidden = true
            if Routine.allRoutines.isEmpty {
                self.routineNameLabel.text = "Nothing to do today? Head over to the workout routines tab and make one up then head over to the calendar and select a workout routine for today!"
            } else {
                self.routineNameLabel.text = "Nothing to do today? Head over to the calendar and select a workout routine for today!"
            }
        }
    }
    
    private func loadUserState() {
        
        Calendar.loadCalendar()
        Routine.loadRoutines()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStartButtonTap(_ sender: AnyObject) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HomeToRoutineDetail") {
            let routineDetailViewController = (segue.destination as! UINavigationController).topViewController as! RoutineDetailViewController
            routineDetailViewController.routine = self.todaysRoutine
        
        }
    }


}
