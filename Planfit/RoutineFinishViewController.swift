//
//  RoutineFinishViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class RoutineFinishViewController: UIViewController {

    @IBOutlet weak var encouragementLabel: UILabel!
    let encouragements = ["You did it!", "Good job!", "Rock on!", "Stay hydrated!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let randomNum = Int(arc4random_uniform(UInt32(encouragements.count)))
        encouragementLabel.text = encouragements[randomNum]
        
        let anim=CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue=NSNumber(value: -M_PI/16)
        anim.fromValue=NSNumber(value: M_PI/16)
        anim.duration=0.1
        anim.repeatCount=5
        anim.autoreverses=true
        encouragementLabel.layer.add(anim, forKey: "shakingAnimation")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
