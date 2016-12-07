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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userRoutines = Routine.allRoutines.sorted {$0.routineName! < $1.routineName! }
        
        routineTableView.dataSource = self
        routineTableView.delegate = self
        
        routineTableView.rowHeight = UITableViewAutomaticDimension
        routineTableView.estimatedRowHeight = 100
        
        routineTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoutineExerciseSegue" {
            let destination = segue.destination as! RoutineDetailViewController
            let senderIndexPath = routineTableView.indexPath(for: sender as! RoutineTableViewCell)!
            destination.routine = userRoutines?[senderIndexPath.row]
        }
    }
}
