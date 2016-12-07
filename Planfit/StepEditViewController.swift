//
//  StepEditViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class StepEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var exercise: Exercise?
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    
    let minutes = Array(0...9)
    let seconds = Array(0...59)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        if (!((exercise?.isNew)!)) {
            loadExercise()
        }
        handleExerciseAutocompleteField()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleExerciseAutocompleteField() {
        
        autocompleteTextfield.autoCompleteStrings = ExerciseNames.list
        
        autocompleteTextfield.onTextChange = {[weak self] text in
            self?.autocompleteTextfield!.autoCompleteStrings = ExerciseNames.list.filter({ (exercise) -> Bool in
                exercise.hasPrefix(text)
            })
        }
        //autocompleteTextfield.onSelect = {[weak self] text, indexpath in
            // your code goes here
        //}
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (component == 0) {
            return minutes.count
        }
        else {
            return seconds.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (component == 0) {
            return String(minutes[row]) + " min"
        } else {
            return String(seconds[row]) + " sec"
        }
    }
    
    @IBAction func onSaveButtonTap(_ sender: UIButton) {
        // TO DO: Save exercise to Parse?
        
        exercise?.exerciseName = autocompleteTextfield.text
        let minutesRow = timePickerView.selectedRow(inComponent: 0)
        let min = minutes[minutesRow]
        let secondsRow = timePickerView.selectedRow(inComponent: 1)
        let sec = seconds[secondsRow]
        let time = (min * 60 + sec) as Int
        exercise?.exerciseDuration = time
        exercise?.reps = Int(repsTextField.text!)
        exercise?.exerciseDescription = notesTextField.text
        exercise?.isNew = false
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func loadExercise() {
        autocompleteTextfield.text = exercise?.exerciseName
        let time = exercise?.exerciseDuration
        let minutes = Int(time! / 60)
        let seconds = Int(time! % 60)
        timePickerView.selectRow(minutes, inComponent: 0, animated: true)
        timePickerView.selectRow(seconds, inComponent: 1, animated: true)
        if (exercise?.reps != nil) {
            repsTextField.text = "\((exercise?.reps!)!)"
        } else {
            repsTextField.text = ""
        }

        notesTextField.text = exercise?.exerciseDescription
    }

    /**
     Dismisses keyboard on tap gesture recognizer
     
     - Parameter None
     
     - Returns: None
     */
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
