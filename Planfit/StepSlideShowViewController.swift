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
    
    
    var routine: Routine!
    var _steps: [Exercise] = []
    var steps: [Exercise] {
        get{
            if (_steps.isEmpty) {
                // return some dummy steps for testing while routine detail screen is under construction
                _steps = getTempSteps()
            }
            return _steps
        }
        set(value) {
            _steps = value
        }
    }
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStep(at: self.stepIndex)
        countdownLabel.delegate = self
        
    }
    
    // return some dummy steps for testing while routine detail screen is under construction
    private func getTempSteps() -> [Exercise] {
        
        let step0 = Exercise(name: "Run", description: "My regular treadmill run", duration: 5, reps: nil, imageURL: "https://goo.gl/0Qhlhp", videoURL: nil)
        let step1 = Exercise(name: "Pushup", description: "Chest, shoulders, arms", duration: 5, reps: nil, imageURL: "https://goo.gl/73nGJB", videoURL: nil)
        let step2 = Exercise(name: "Maru Swings", description: "Just swinging", duration: 5, reps: nil, imageURL: nil, videoURL: "https://youtu.be/rnj6cnlIjM4?t=170")
        let steps = [step0, step1, step2]
        
        return steps
    }
    
    @IBAction func onNextButtonTap(_ sender: AnyObject) {
        
        self.goToNextStep()        
    }
    
    private func loadStep(at index: Int) {
        
        self.stepIndex += 1
        let step = steps[index]
    
        self.nameLabel.text = step.exerciseName
        if let description = step.exerciseDescription {
            self.descriptionLabel.text = description
        }
        if let duration = step.exerciseDuration {
            countdownLabel.setTime(seconds: Double(duration))
            countdownLabel.setCompletionText(text: "You did it!")
            countdownLabel.start()
        }
        if let image = step.exerciseImageURL {
            mediaView.setImageWith(image)
        }
        if let video = step.exerciseVideoURL {
            mediaView.setImageWith(video)
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
        
        if (self.stepIndex == steps.count) {
            self.performSegue(withIdentifier: "SlideShowToFinish", sender: nil)
        } else {
            loadStep(at: self.stepIndex)
        }
    }

}
