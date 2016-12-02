//
//  RoutineDetailViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class RoutineDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var exerciseListTable: UITableView!
    var routine: Routine!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exerciseListTable.dataSource = self
        exerciseListTable.delegate = self
        exerciseListTable.rowHeight = UITableViewAutomaticDimension
        exerciseListTable.estimatedRowHeight = 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "RoutineDetailToSlideShowSegue") {
            let slideShowViewController = segue.destination as! StepSlideShowViewController
            //slideShowViewController.routine = self.todaysRoutine
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let exerciseIds = self.routine.exerciseIds else {
            return 0
        }
        return exerciseIds.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseListTable.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell
        cell.exercise = getExercise(for: indexPath.row)
        cell.updateLabel()
        return cell
    }
    
    func getExercise(for indexPath: Int) -> Exercise {
        // Replace this method with actual server call
        return Exercise(name: "Exercise \(indexPath)", description: "This is a description for this exercise.", duration: 5, reps: 10, imageURL: nil, videoURL: nil)
    }

}
