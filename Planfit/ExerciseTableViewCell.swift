//
//  ExerciseTableViewCell.swift
//  Planfit
//
//  Created by Minnie Lai on 11/29/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    var exercise : Exercise?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabel() {
        if let exercise = exercise {
            if exercise.exerciseName != nil {
                exerciseNameLabel.text = exercise.exerciseName!
            }
            if exercise.exerciseDescription != nil {
                descriptionLabel.text = exercise.exerciseDescription!
            }
            if exercise.exerciseDuration != nil {
                let minutes = (exercise.exerciseDuration!/60)
                let seconds = exercise.exerciseDuration! % 60
                durationLabel.text = "\(minutes) min \(seconds) sec"
            }
            var repsLabelString = ""
            if exercise.reps != nil {
                repsLabelString = "\(exercise.reps!) reps"
            }
            if exercise.totalSets != nil {
                repsLabelString = repsLabelString + "for \(exercise.totalSets!) total sets"
            }
            repsLabel.text = repsLabelString
        }
    }

}
