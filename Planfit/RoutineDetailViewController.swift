//
//  RoutineDetailViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class RoutineDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var routineTitlePlaceholderLabel: UILabel!
    @IBOutlet weak var routineDescriptionPlaceholderLabel: UILabel!
    @IBOutlet weak var exerciseListTable: UITableView!
    var routine: Routine?
    @IBOutlet weak var routineTitle: UITextView!
    @IBOutlet weak var routineDescription: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exerciseListTable.dataSource = self
        exerciseListTable.delegate = self
        exerciseListTable.rowHeight = UITableViewAutomaticDimension
        exerciseListTable.estimatedRowHeight = 100
        
        routineTitle.delegate = self
        routineDescription.delegate = self
        
        if let existingRoutine = routine {
            routineTitle.text = existingRoutine.routineName
            routineDescription.text = existingRoutine.routineDescription
            textViewDidChange(routineTitle)
            textViewDidChange(routineDescription)
        } else {
            routineTitle.text = ""
            routineDescription.text = ""
        }
        
        exerciseListTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        routine?.exercises = (routine?.exercises.filter({ (i) -> Bool in
            return !i.isNew
        }))!
        exerciseListTable.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if(!(routine?.isCancelled)!) {
            routine?.routineName = routineTitle.text
            routine?.routineDescription = routineDescription.text
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "RoutineDetailToSlideShowSegue") {
            let slideShowViewController = segue.destination as! StepSlideShowViewController
            slideShowViewController.routine = self.routine
        } else if (segue.identifier == "RoutineDetailToStepEdit") {
            let selectedRow = exerciseListTable.indexPathForSelectedRow?.row
            let stepEditViewController = segue.destination as! StepEditViewController
            if (selectedRow! < (routine?.exercises.count)!) {
                stepEditViewController.exercise = routine?.exercises[selectedRow!]
            } else {
                let newExercise = Exercise()
                newExercise.isNew = true
                routine?.exercises.append(newExercise)
                stepEditViewController.exercise = newExercise
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (routine?.exercises.isEmpty)! ? 1 : (routine?.exercises.count)! + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < exerciseListTable.numberOfRows(inSection: indexPath.section) - 1) {
            let cell = exerciseListTable.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseTableViewCell
            cell.exercise = routine?.exercises[indexPath.row]
            cell.updateLabel()
            return cell
        } else {
            let cell = exerciseListTable.dequeueReusableCell(withIdentifier: "addExerciseCell", for: indexPath)
            return cell
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == routineTitle) {
            routine?.routineName = textView.text
        } else if (textView == routineDescription) {
            routine?.routineDescription = textView.text
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "RoutineDetailToStepEdit", sender: self)
    }

    func textViewDidChange(_ textView: UITextView) {
        if (textView == routineTitle) {
            if (textView.text.isEmpty) {
                routineTitlePlaceholderLabel.isHidden = false
            } else {
                routineTitlePlaceholderLabel.isHidden = true
            }
        } else if (textView == routineDescription) {
            if (textView.text.isEmpty) {
                routineDescriptionPlaceholderLabel.isHidden = false
            } else {
                routineDescriptionPlaceholderLabel.isHidden = true
            }
        }
    }
    
    @IBAction func onCancelButtonTap(_ sender: AnyObject) {

        routine?.isCancelled = true
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            routine?.exercises.remove(at: indexPath.row)
            exerciseListTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if (indexPath.row > (routine?.exercises.count)! - 1) {
            return false
        }
        return true
    }

}
