//
//  RoutineTableViewCell.swift
//  Planfit
//
//  Created by Estella Lai on 11/21/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {

    @IBOutlet weak var routineNameLabel: UILabel!
    var routine : Routine?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let routine = routine {
            routineNameLabel.text = routine.description
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
