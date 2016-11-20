//
//  AccountViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {

    var user : UserDataModel?
    var passwordChanged = false
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        user = UserDataModel(parseObject: ParseUserAPIClient.sharedInstance.getCurrentUser()!)
        if let currentUser = user {
            emailTextField.text = currentUser.email
            passwordTextField.text = "Type in a new password here"
            userNameTextField.text = currentUser.username
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Determines whether the user has changed their information
     
     - Parameter: None
     
     - Returns: Bool
     */
    func needsUpdate() -> Bool {
        guard let user = user else {
            return false;
        }
        
        let newUserName = userNameTextField.text
        let newEmail = emailTextField.text
        
        if user.username != newUserName || passwordChanged || user.email != newEmail {
            return true;
        } else {
            return false;
        }
    }

    /**
     Updates user information
     
     - Parameter sender: AnyObject
     
     - Returns: None
     */
    @IBAction func onUpdateClicked(_ sender: AnyObject) {
        let newUser = UserDataModel(username: userNameTextField.text!,
                                    password: passwordTextField.text!,
                                    email: emailTextField.text!)
        if needsUpdate() {
            var alert : UIAlertController!
            ParseUserAPIClient.sharedInstance.update(user: newUser, success: { (user) in
                    alert = UIAlertController(title: "OK", message: "Your settings have been saved.", preferredStyle: UIAlertControllerStyle.alert)
                }, failure: { (error) in
                    alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            })
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    /**
     Updates passwordChange boolean when the password text field finishes editing
     
     - Parameter None
     
     - Returns: None
     */
    @IBAction func onPasswordChanged(_ sender: AnyObject) {
        self.passwordChanged = true
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
    
    /**
     Dismisses keyboard on keyboard Return key
     
     - Parameter None
     
     - Returns: None
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
