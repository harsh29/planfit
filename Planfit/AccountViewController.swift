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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    /**
     Updates view dimensions when keybaord is shown.
     
     - Parameter notification: NSNotification
     
     - Returns: None
     */
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    /**
     Updates view dimensions when keybaord is hidden.
     
     - Parameter notification: NSNotification
     
     - Returns: None
     */
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
                        // updates user
                        self.user = UserDataModel(parseObject: ParseUserAPIClient.sharedInstance.getCurrentUser()!)
                })
                self.successfulMessageView.isHidden = false
            }, failure: { (error) in
                self.errorLabel.text = "Update unsuccessful!"
                UIView.animate(withDuration: 3, animations: {
                    self.failureMessageView.alpha = 1.0}, completion: { (bool) in
                        self.failureMessageView.alpha = 0.0
                        self.emailTextField.text = self.user?.email
                        self.userNameTextField.text = self.user?.username
                })
            })
        } else {
            errorLabel.text = "You have made no changes."
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
    
    /**
     Logs out user
     
     - Parameter sender: AnyObject
     
     - Returns: None
     */
    @IBAction func logoutClicked(_ sender: Any) {
        ParseUserAPIClient.sharedInstance.logout(success: {
            NSLog("User \(self.user?.username) is logged out.")
        }, failure: { (error) in
            self.errorLabel.text = "Logout unsuccessful!"
            UIView.animate(withDuration: 3, animations: {
                self.failureMessageView.alpha = 1.0}, completion: { (bool) in
                    self.failureMessageView.alpha = 0.0
            })
        })
    }
}
