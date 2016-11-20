//
//  LoginViewController.swift
//  Planfit
//
//  Created by Olya Sorokina on 11/11/16.
//  Copyright © 2016 Planfit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginOnClick(_ sender: Any) {
        guard let username = usernameTextField.text, usernameTextField.text != "",
            let password = passwordTextField.text, passwordTextField.text != "" else {
                NSLog("Both username and password are required")
                return
        }
        let loginUser = UserDataModel(username: username, password: password, email: "")
        ParseUserAPIClient.sharedInstance.login(user: loginUser, success: {
            self.performSegue(withIdentifier: "LoginToHomeSegue", sender: sender)
        }, failure: { (error) in
            NSLog(error.localizedDescription)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
