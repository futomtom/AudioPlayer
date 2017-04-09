//
//  IntentHandler.swift
//  SiriIntent
//
//  Created by Alex on 4/8/17.
//  Copyright © 2017 alex. All rights reserved.
//


import Intents

class IntentHandler: INExtension, INStartWorkoutIntentHandling {
    override func handler(for intent: INIntent) -> Any? {
        return self
    }
    func handle(startWorkout intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        let activity = NSUserActivity(activityType: "Workout")
        let workout:String = intent.workoutName!.spokenPhrase!
        print(workout)
        activity.userInfo = ["workoutName":workout]
        completion(INStartWorkoutIntentResponse(code: .continueInApp, userActivity: activity))
    }
    
    func confirm(startWorkout intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        completion(INStartWorkoutIntentResponse(code: .ready, userActivity: nil))
    }
    
    func resolveWorkoutName(forStartWorkout intent: INStartWorkoutIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        
        if let workout = intent.workoutName {
            print("1 \(workout)")
            completion(INSpeakableStringResolutionResult.success(with: workout))
        }
        else {
            completion(INSpeakableStringResolutionResult.needsValue())
        }
    }
    
    func resolveGoalValue(forStartWorkout intent: INStartWorkoutIntent, with completion: @escaping (INDoubleResolutionResult) -> Void) {
        let goalValue = (intent.goalValue != nil) ? intent.goalValue! : Double(0)
        completion(INDoubleResolutionResult.success(with: goalValue))
    }
    
    
}


