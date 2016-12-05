//
//  CountDownLabel.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/20/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

protocol CountDownDelegate {
    func didFinishCountDown(source: CountDownLabel) -> Void
}

class CountDownLabel: UILabel {
    
    let updateInterval = 0.01
    var totalSeconds = 0.0
    var endDateTime: NSDate = NSDate()
    
    var completionText: String = ""
    var delegate: CountDownDelegate?
    var cancelled = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCompletionText(text: String) {
        completionText = text;
    }
    
    func setTime(seconds: Double = 0, milliseconds: Double = 0) {
         totalSeconds = seconds + (milliseconds / 1000)
    }

    func start() {
        cancelled = false
        endDateTime = NSDate.init(timeIntervalSinceNow: totalSeconds)
        
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { (timer) in
            if (self.cancelled) {
                timer.invalidate()
            }
            if (self.didFinish()) {
                self.text = self.completionText;
                self.delegate?.didFinishCountDown(source: self)
                timer.invalidate()
            } else {
                self.updateText()
            }
        }
    }
    
    public func cancel() {
        cancelled = true
    }
    
    private func didFinish() -> Bool {
        return endDateTime.timeIntervalSinceNow < 0
    }
    
    func updateText() {
        let timeUntilEnd = endDateTime.timeIntervalSinceNow
        var remainingTimeToDisplay = Int(timeUntilEnd)
        
        let hours = remainingTimeToDisplay / 3600
        remainingTimeToDisplay = remainingTimeToDisplay % 3600
        let minutes = remainingTimeToDisplay / 60
        remainingTimeToDisplay = remainingTimeToDisplay % 60
        let seconds = remainingTimeToDisplay
        let milliseconds = Int(100 * (timeUntilEnd - timeUntilEnd.rounded(FloatingPointRoundingRule.down)))
        
        self.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds)
    }

}
