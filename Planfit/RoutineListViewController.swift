//
//  RoutineListViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class RoutineListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var routineTableView: UITableView!
    var userRoutines : [Routine]?
    var rowHeight: Float?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRoutines = userRoutines?.filter({ (i) -> Bool in
            return !i.isCancelled
        })

        routineTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        self.rowHeight = Float(cell.routineNameLabel.frame.height + 20)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoutineExerciseSegue" {
            let destination = segue.destination as! RoutineDetailViewController
            let senderIndexPath = routineTableView.indexPath(for: sender as! RoutineTableViewCell)!
            destination.routine = userRoutines?[senderIndexPath.row]
        }
        if segue.identifier == "RoutineListToNewRoutine" {
            let destination = segue.destination as! RoutineDetailViewController
            let newRoutine = Routine()
            destination.routine = newRoutine
            userRoutines?.append(newRoutine)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            userRoutines!.remove(at: indexPath.row)
            routineTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if rowHeight != nil {
            return CGFloat(rowHeight!)
        }
        return UITableViewAutomaticDimension
    }
}
