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

        // Do any additional setup after loading the view.
        // userRoutines = Routine.allRoutines
        let exampleRoutine = Routine(json: ["description" : "Cardio Blast",
                                            "id" : UUID.init(uuidString: "e06a08e0-0687-4f33-8870-e64113b6f68a") as Any,
                                            "owner" : ["owner" : "minnie", "avatar_url" : "https://scontent.xx.fbcdn.net/v/t1.0-1/c0.2.50.50/p50x50/13709755_10201927466626271_4964123079867840378_n.jpg?oh=613ff325f2fd88bedf5e24f0de10b028&oe=58B5EA5B"]])
        userRoutines = [exampleRoutine!]
        routineTableView.dataSource = self
        routineTableView.delegate = self
        
        routineTableView.rowHeight = UITableViewAutomaticDimension
        routineTableView.estimatedRowHeight = 100
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
        return cell
    }
    
}
