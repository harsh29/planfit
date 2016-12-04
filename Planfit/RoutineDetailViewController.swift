//
//  RoutineDetailViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class RoutineDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var exerciseListTable: UITableView!
    var routine: Routine!
    @IBOutlet weak var routineTitle: UITextView!
    @IBOutlet weak var routineDescription: UITextView!
    var exercises: [Exercise] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exerciseListTable.dataSource = self
        exerciseListTable.delegate = self
        exerciseListTable.rowHeight = UITableViewAutomaticDimension
        exerciseListTable.estimatedRowHeight = 100
        
        routineTitle.delegate = self
        routineDescription.delegate = self
        
        routineTitle.text = routine.routineName
        routineDescription.text = routine.routineDescription
        
        exercises = Routine.getExerciseSet(count: 3)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "RoutineDetailToSlideShowSegue") {
            let slideShowViewController = segue.destination as! StepSlideShowViewController
            slideShowViewController.routine = self.routine
        } else if (segue.identifier == "RoutineDetailToStepEdit") {
            let selectedRow = exerciseListTable.indexPathForSelectedRow?.row
            let stepEditViewController = segue.destination as! StepEditViewController
            if (selectedRow! < exercises.count) {
                stepEditViewController.exercise = exercises[selectedRow!]
            } else {
                let newExercise = Exercise(name: nil, description: nil, duration: nil, reps: nil, imageURL: nil, videoURL: nil)
                exercises.append(newExercise)
                stepEditViewController.exercise = newExercise
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let exerciseIds = self.routine.exerciseIds else {
            return 1
        }
        return exerciseIds.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < exerciseListTable.numberOfRows(inSection: indexPath.section) - 1) {
            let cell = exerciseListTable.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell
            cell.exercise = exercises[indexPath.row]
            cell.updateLabel()
            return cell
        } else {
            let cell = exerciseListTable.dequeueReusableCell(withIdentifier: "addExerciseCell", for: indexPath)
            return cell
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == routineTitle) {
            routine.routineName = textView.text
        } else if (textView == routineDescription) {
            routine.routineDescription = textView.text
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "RoutineDetailToStepEdit", sender: self)
    }
    


}
