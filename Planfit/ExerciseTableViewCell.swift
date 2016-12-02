//
//  ExerciseTableViewCell.swift
//  Planfit
//
//  Created by Minnie Lai on 11/29/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
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
            exerciseNameLabel.text = exercise.exerciseName
        }
    }

}
