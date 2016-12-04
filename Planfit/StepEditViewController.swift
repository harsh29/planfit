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
    
    let minutes = Array(0...9)
    let seconds = Array(0...59)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.delegate = self
        timePickerView.dataSource = self
        handleExerciseAutocompleteField()

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
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
            // your code goes here
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        let row = pickerView.selectedRow(inComponent: 0)
        print("this is the pickerView\(row)")
        
        if component == 0 {
            return minutes.count
        }
        else {
            return seconds.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return String(minutes[row]) + " min"
        } else {
            return String(seconds[row]) + " sec"
        }
    }
    
    @IBAction func onSaveButtonTap(_ sender: UIButton) {
        
        //TO DO: save step info and pass it back to routine detail
    }

}
