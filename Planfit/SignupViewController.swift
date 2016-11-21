//
//  SignupViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Signs a user up onto the Parse Server
     
     - Parameter sender: Any.

     - Returns: None
     */
    @IBAction func onSignUpClick(_ sender: Any) {
        guard let username = userNameTextField.text, userNameTextField.text != "",
            let password = passwordTextField.text, passwordTextField.text != "",
            let email = emailTextField.text, emailTextField.text != ""
            else {
                NSLog("Cannot sign user up, missing required fields.")
                return
            }
        
        let newUser = UserDataModel(username: username, password: password, email: email)
        ParseUserAPIClient.sharedInstance.signUp(user: newUser, success: {
            self.performSegue(withIdentifier: "HomeSegue", sender: sender)
            
        }, failure: {(error) in
            NSLog("Something bad happened.")
            NSLog(error.localizedDescription)
        })
    }

    /**
     Dismisses keyboard on keyboard Return key
     
     - Parameter None
     
     - Returns: None
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     Dismisses keyboard on tap gesture recognizer
     
     - Parameter None
     
     - Returns: None
     */
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
