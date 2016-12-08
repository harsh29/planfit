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
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
