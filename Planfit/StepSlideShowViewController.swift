//
//  StepDetailViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit
import AFNetworking


class StepSlideShowViewController: UIViewController, CountDownDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countdownLabel: CountDownLabel!
    @IBOutlet weak var mediaView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var routine: Routine!
    var steps: [Exercise] {
        get{
            return routine.exercises
        }
    }
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        loadStep(at: self.stepIndex)
        countdownLabel.delegate = self
        countdownLabel.start()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stepIndex = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        countdownLabel.cancel()
    }
    
    @IBAction func onNextButtonTap(_ sender: AnyObject) {
        
        self.goToNextStep()        
    }
    
    private func loadStep(at index: Int) {
        
        if (index < steps.count) {
            let step = steps[index]
        
            self.nameLabel.text = step.exerciseName
            if let description = step.exerciseDescription {
                self.descriptionLabel.text = description
            }
            if let duration = step.exerciseDuration {
                countdownLabel.setTime(seconds: Double(duration))
            }
            mediaView.image = step.exerciseImage
            
            if let video = step.exerciseVideoURL {
                mediaView.setImageWith(video)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishCountDown(source: CountDownLabel) -> Void {
        
        self.goToNextStep()
        NSLog("Timer finished")
    }
    
    private func goToNextStep() {
        self.stepIndex += 1
        if (self.stepIndex == steps.count) {
            countdownLabel.cancel()
            self.performSegue(withIdentifier: "SlideShowToFinish", sender: nil)
        } else {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.contentViewLeadingConstraint.constant = -self.contentView.frame.size.width
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.contentViewLeadingConstraint.constant = self.contentView.frame.size.width
                self.view.layoutIfNeeded()
                self.loadStep(at: self.stepIndex)

                UIView.animate(withDuration: 0.5, animations: {
                    self.contentViewLeadingConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    self.countdownLabel.start()
                })
            })
        }
    }

}
