//
//  MockAPICalls.swift
//  Planfit
//
//  Created by Minnie Lai on 12/7/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import Foundation

class MockAPICalls {
    
    func getExercisesForRoutineCardioBlast() -> [Exercise] {
        let step0 = Exercise(name: "Burpees", description: "Jump up and plank low", duration: 10, reps: 10, imageURL: nil, image: nil, videoURL: nil)
        let step1 = Exercise(name: "Jump Squats", description: "Squat and spring up to jump", duration: 20, reps: 20, imageURL: nil, image: nil, videoURL: nil)
        let step2 = Exercise(name: "Mountain Climbers", description: "Plank and alternate bringing your knees into your chest.", duration: 10, reps: 20, imageURL: nil, image: nil, videoURL: nil)
        let steps = [step0, step1, step2]
        return steps
    }
    
    func getExercisesForRoutineLegDay() -> [Exercise] {
        let step0 = Exercise(name: "High Knees", description: "Quick warm up.", duration: 5, reps: nil, imageURL: "https://goo.gl/0Qhlhp", image: nil, videoURL: nil)
        let step1 = Exercise(name: "Deadlift", description: "Use 100 pound weights", duration: 5, reps: nil, imageURL: "https://goo.gl/73nGJB", image: nil, videoURL: nil)
        let step2 = Exercise(name: "Lunges", description: "Just lunging.", duration: 5, reps: nil, imageURL: nil, image: nil, videoURL: "https://youtu.be/rnj6cnlIjM4?t=170")
        let step3 = Exercise(name: "Squats", description: "Plain old squats.", duration: 5, reps: nil, imageURL: nil, image: nil, videoURL: "https://youtu.be/rnj6cnlIjM4?t=170")
        let steps = [step0, step1, step2, step3]
        return steps
    }
    
    func getExercisesForRoutineCrossfit() -> [Exercise] {
        let step0 = Exercise(name: "Box Jump", description: "Use a 12 inch box/", duration: 5, reps: 20, imageURL: "https://goo.gl/0Qhlhp", image: nil, videoURL: nil)
        let steps = [step0]
        return steps
    }
    
}
