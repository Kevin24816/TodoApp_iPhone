//
//  SignUpViewController.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/28/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var signInUsernameTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!
    @IBOutlet weak var signInStatusLabel: UILabel!
    
    @IBOutlet weak var signUpUsernameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpPasswordConfTextField: UITextField!
    @IBOutlet weak var signUpStatusLabel: UILabel!
    
    @IBAction func signinPressed(_ sender: UIButton) {
        guard let username = signInUsernameTextField.text, let password = signInPasswordTextField.text else {
            print("error: text fields are nil")
            return
        }
        
        guard !username.isEmpty, !password.isEmpty else {
            signInStatusLabel.text = "Please fill in all fields above"
            signInStatusLabel.isHidden = false
            return
        }
        
//        print("sign in pressed: )
        NetworkController.login(username: username, password: password, viewCompletionHandler: authHandler(success:response:error:))
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        guard let username = signUpUsernameTextField.text, let password = signUpPasswordTextField.text, let password_conf = signUpPasswordConfTextField.text else {
            return
        }
        
        guard !username.isEmpty, !password.isEmpty, !password_conf.isEmpty else {
            signUpStatusLabel.text = "Please fill in all fields above"
            signUpStatusLabel.isHidden = false
            return
        }
        
        NetworkController.signup(username: username, password: password, passwordConf: password_conf, viewCompletionHandler: authHandler(success:response:error:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let signInPassword = signInPasswordTextField {
            signInPassword.isSecureTextEntry = true
        }
        if let signUpPassword = signUpPasswordTextField {
            signUpPassword.isSecureTextEntry = true
        }
        if let signUpPasswordConf = signUpPasswordConfTextField {
            signUpPasswordConf.isSecureTextEntry = true
        }
    }

    // view handler to handle segueing to the notes view once authentication has been confirmed by server
    private func authHandler(success: Bool, response: Any?, error: Error?) {
        if !success {
            DispatchQueue.main.async {
                if self.signInStatusLabel != nil {
                    self.signInStatusLabel.text = "Username or password invalid"
                    self.signInStatusLabel.isHidden = false
                }
                
                if self.signUpStatusLabel != nil {
                    self.signUpStatusLabel.text = "Username or password invalid"
                    self.signUpStatusLabel.isHidden = false
                }
            }
            return
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "notes", sender: nil)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}
