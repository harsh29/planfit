//
//  CalendarViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit
import CVCalendar
import Foundation
import Eureka
import BTNavigationDropdownMenu

class CalendarViewController: UIViewController {
    struct Color {
        static let selectedText = UIColor.white
        static let text = UIColor.black
        static let textDisabled = UIColor.gray
        static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
    
    
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var selectedDate: Date?
    
    var selectedDay:DayView!
    
    var currentCalendar: Foundation.Calendar?
    
    var plannedRoutines : [PlannedDay]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plannedRoutines = Calendar.getAllPlannedWorkouts()
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Foundation.Calendar.init(identifier: .gregorian)
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
        
        if let currentCalendar = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        
        //Initialize drop down menu
        //Menu
        let items = ["Monthly Calendar", "Weekly Calendar"]
        
        let dropDownMenuView = BTNavigationDropdownMenu(title: items.first!, items: items as [AnyObject])
        dropDownMenuView.cellHeight = 40
        dropDownMenuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        dropDownMenuView.cellSelectionColor = UIColor(netHex:0xFF5400)
        dropDownMenuView.cellTextLabelColor = UIColor.white
        dropDownMenuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        dropDownMenuView.arrowPadding = 15
        dropDownMenuView.animationDuration = 0.5
        dropDownMenuView.maskBackgroundColor = UIColor.black
        dropDownMenuView.maskBackgroundOpacity = 0.3
        dropDownMenuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self.dealWithNavBarSelection(indexPath)
        }
        
        //Initialize dropdown menu
        self.navigationItem.titleView = dropDownMenuView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
       tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    func dealWithNavBarSelection(_ indexSelected: Int){
        //monthly
        if(indexSelected == 0){
            self.calendarView.changeMode(.monthView)
        }
        //weekly
        if(indexSelected == 1){
            self.calendarView.changeMode(.weekView)
            print("week view")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(calendarView.presentedDate.commonDescription) is selected!")
        if((selectedDay != nil) && selectedDay == dayView){
            dayView.setDeselectedWithClearing(true);
            plannedRoutines = Calendar.plannedDays
            tableView.reloadData();
        }else{
            self.selectedDay = dayView
            let currentDate = calendarView.presentedDate.convertedDate(calendar: currentCalendar!)
            if let currentDate = currentDate{
                selectedDate = currentDate
            }else{
                selectedDate = Date()
            }
            print(currentDate)
            plannedRoutines = Calendar.plannedDays
            for day in plannedRoutines! {
                print(selectedDate)
                print(day.date)
                let dayMonth = Foundation.Calendar.current.component(.month, from: day.date)
                let dayDay = Foundation.Calendar.current.component(.day, from: day.date)
                let selectedMonth = Foundation.Calendar.current.component(.month, from: selectedDate!)
                let selectedDateDay = Foundation.Calendar.current.component(.day, from: selectedDate!)
                
                if((dayDay == selectedDateDay) && (dayMonth == selectedMonth)){
                    plannedRoutines = [day]
                    tableView.reloadData()
                    break
                }else{
                    plannedRoutines = []
                    tableView.reloadData()
                }
            }
        }
    }
    
    /*
    @nonobjc func didSelectDayView(_ dayView: CVCalendarDayView) {
        print("\(calendarView.presentedDate.commonDescription) is selected!")
        
        // Fetch all events happening in the next 24 hours and put them into eventsList
        let currentDate = calendarView.presentedDate.convertedDate(calendar: currentCalendar!)
        //self.eventsList = self.fetchEvents(currentDate! as Date)
        
        // Update the UI with the above events
        //reloadTable()
    }
    */
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
//        var tempEventsList: [EKEvent] = []
//        tempEventsList = fetchEvents(dayView.date.convertedDate(calendar: currentCalendar)! as Date)
//        if(!tempEventsList.isEmpty){
//            return true
//        }
//        return false
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        return [UIColor.red]
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
    
}

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor.orange
    }
    
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}



extension CalendarViewController {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.isOn {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.weekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.monthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

extension CalendarViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar) // from today
        
        components.month! += offset
        
        let resultDate = currentCalendar.date(from: components)!
        self.calendarView.toggleViewWithDate(resultDate)
        self.calendarView.appearance.dayLabelPresentWeekdayHighlightedBackgroundAlpha = nil
        self.calendarView.appearance.dayLabelPresentWeekdayHighlightedBackgroundColor = nil
    }
    
    func didShowNextMonthView(date: NSDate) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        let components = Manager.componentsForDate(date as Date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        
        let components = Manager.componentsForDate(date as Date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let plannedRoutines = self.plannedRoutines {
            return plannedRoutines.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! RoutineTableViewCell
        cell.routine = plannedRoutines?[indexPath.row].routine
        cell.updateLabel()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RoutineSelectSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoutineExerciseSegue" {
            let destination = segue.destination as! RoutineDetailViewController
            let senderIndexPath = tableView.indexPath(for: sender as! RoutineTableViewCell)!
            destination.routine = plannedRoutines?[senderIndexPath.row].routine
            destination.navigationItem.rightBarButtonItem = nil
        }else if segue.identifier == "RoutineSelectSegue" {
            let destination = segue.destination as! CalendarRoutineListViewController
            destination.selectedDate = selectedDate!
        }
    }
}

