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

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var failureMessageView: UIView!
    @IBOutlet weak var successfulMessageView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        user = UserDataModel(parseObject: ParseUserAPIClient.sharedInstance.getCurrentUser()!)
        if let currentUser = user {
            emailTextField.text = currentUser.email
            userNameTextField.text = currentUser.username
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        successfulMessageView.alpha = 0.0
        failureMessageView.alpha = 0.0

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
        
        if user.username != newUserName || passwordTextField.text != "" || user.email != newEmail {
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
            ParseUserAPIClient.sharedInstance.update(user: newUser, success: { (user) in
                UIView.animate(withDuration: 3, animations: {
                    self.successfulMessageView.alpha = 1.0}, completion: { (bool) in
                        self.successfulMessageView.alpha = 0.0
                })
                self.successfulMessageView.isHidden = false
            }, failure: { (error) in
                self.errorLabel.text = "Update unsuccessful!"
                UIView.animate(withDuration: 3, animations: {
                    self.failureMessageView.alpha = 1.0}, completion: { (bool) in
                        self.failureMessageView.alpha = 0.0
                })
            })
        } else {
            errorLabel.text = "You have made no change."
            UIView.animate(withDuration: 3, animations: {
                self.failureMessageView.alpha = 1.0}, completion: { (bool) in
                    self.failureMessageView.alpha = 0.0
            })

        }
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
