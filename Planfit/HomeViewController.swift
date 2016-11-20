//
//  HomeViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var routineStartView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var routineNameLabel: UILabel!
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        routineStartView.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        routineStartView.layer.shadowRadius = 2.0
        routineStartView.layer.shadowOpacity = 0.5
        routineStartView.layer.masksToBounds = false
        
        routineStartView.layer.borderColor = UIColor.black.cgColor
        routineStartView.layer.borderWidth = 1
        
        let date = HomeViewController.formatter.string(from: Date())
        self.dateLabel.text = date
        
        let routine = Calendar.getTodaysRoutine()
        self.routineNameLabel.text = routine?.routineName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStartButtonTap(_ sender: AnyObject) {
    }


}
