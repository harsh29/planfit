//
//  CalendarRoutineListViewController.swift
//  Planfit
//
//  Created by Harsh Trivedi on 12/7/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class CalendarRoutineListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var routineTableView: UITableView!
    var userRoutines : [Routine]?
    var selectedDate : Date?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRoutines = Routine.allRoutines
        
        routineTableView.dataSource = self
        routineTableView.delegate = self
        
        routineTableView.reloadData()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        routineTableView.rowHeight = UITableViewAutomaticDimension
        routineTableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRoutines = userRoutines?.filter({ (i) -> Bool in
            return !i.isCancelled
        })
        
        routineTableView.reloadData()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userRoutines = self.userRoutines {
            return userRoutines.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = routineTableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! RoutineTableViewCell
        cell.routine = userRoutines?[indexPath.row]
        cell.updateLabel()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plannedDay = PlannedDay()
        plannedDay.date = selectedDate
        plannedDay.routine = userRoutines?[indexPath.row]
        Calendar.plannedDays.append(plannedDay)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func onCancelButtonTap(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
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
