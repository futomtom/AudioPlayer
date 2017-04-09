//
//  WorkoutVC.swift
//  AudioPlayer
//
//  Created by Alex on 4/8/17.
//  Copyright © 2017 alex. All rights reserved.
//

import UIKit
import Intents

class WorkoutVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        INPreferences.requestSiriAuthorization { (status:INSiriAuthorizationStatus) in
            switch (status) {
            case INSiriAuthorizationStatus.authorized :
                print("siri is authorized")
                break
            default :
                print("siri is not authorized")
            }
        }
    }
    
    func showData() {
        if let workout = self.userActivity?.userInfo?["workoutName"] as? String {
            print(workout)
            imageView.image = UIImage(named: workout.lowercased())
        }
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        print("updateUserActivityState \(activity.userInfo)")
    }

}
