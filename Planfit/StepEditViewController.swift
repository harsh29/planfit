//
//  StepEditViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class StepEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var exercise: Exercise?
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var mediaView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    
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
        exercise?.exerciseImage = mediaView.image
        
        self.navigationController?.popViewController(animated: true)
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
        if let image = exercise?.exerciseImage {
            mediaView.image = image
            photoButton.isHidden = true
        } else {
            photoButton.isHidden = false
        }
    }

    @IBAction func onPhotoButtonTap(_ sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        photoButton.isHidden = true
        mediaView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        mediaView.image = editedImage
        photoButton.isHidden = true
        self.dismiss(animated: true, completion: nil);
    }
}
