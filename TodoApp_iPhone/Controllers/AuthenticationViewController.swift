//
//  SignUpViewController.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/28/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let notesVC = segue.destination as? NotesViewController {
            // pass the model
        }
    }

    @IBOutlet weak var signInUsernameField: UITextField!
    @IBOutlet weak var signInPasswordField: UITextField!
    @IBOutlet weak var signInStatus: UILabel!
    
    @IBOutlet weak var signUpUsernameField: UITextField!
    @IBOutlet weak var signUpPasswordField: UITextField!
    @IBOutlet weak var signUpPasswordConfField: UITextField!
    @IBOutlet weak var signUpStatus: UILabel!
    
    @IBAction func signinPressed(_ sender: UIButton) {
        guard let username = signInUsernameField.text, let password = signInPasswordField.text else {
            print("error: text fields are nil")
            return
        }
        
        guard !username.isEmpty, !password.isEmpty else {
            print("username: \(username), password: \(password)")
            signInFailed(withMsg: "Please fill in all fields above")
            return
        }
        
        // authenticate user
        let model = TodoModel()
        model.login(username: username, password: password, completionHandler: loginAuthenticated(success:response:error:))
    }
    
    func loginAuthenticated(success: Bool, response: Any?, error: Error?) {
        guard let authData = response as? [String: String] else {
            return
        }
        print("data received in view: \(authData)")
        performSegue(withIdentifier: "notes", sender: nil)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        guard signUpUsernameField.text != "", signUpPasswordField.text != "", signUpPasswordConfField.text != ""
            else {
                signUpFailed(withMsg: "Please fill in all fields above")
                return
        }
        

        
//        performSegue(withIdentifier: "notes", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func signInFailed(withMsg message: String) {
        signInStatus.text = message
        signInStatus.isHidden = false
    }
    
    private func signUpFailed(withMsg message: String) {
        signUpStatus.text = message
        signUpStatus.isHidden = false
    }

}
