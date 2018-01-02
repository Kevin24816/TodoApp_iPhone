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
            notesVC.model = model
        }
    }
    
    var model: TodoModel? // should this be optional?

    @IBOutlet weak var signInUsernameField: UITextField!
    @IBOutlet weak var signInPasswordField: UITextField!
    @IBOutlet weak var signInStatus: UILabel!
    
    @IBOutlet weak var signUpUsernameField: UITextField!
    @IBOutlet weak var signUpPasswordField: UITextField!
    @IBOutlet weak var signUpPasswordConfField: UITextField!
    @IBOutlet weak var signUpStatus: UILabel!
    
    @IBAction func signinPressed(_ sender: UIButton) {
        guard signInUsernameField.text != "", signInPasswordField.text != ""
            else {
                signInFailed(withMsg: "Please fill in all fields above")
                return
        }
        
        // authenticate user
        model = TodoModel()
        let (successful, message) = (model?.login(username: signInUsernameField.text!, password: signInPasswordField.text!))!
        guard successful == true
            else {
                signInFailed(withMsg: message)
                return
        }
        
        performSegue(withIdentifier: "notes", sender: nil)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        guard signUpUsernameField.text != "", signUpPasswordField.text != "", signUpPasswordConfField.text != ""
            else {
                signUpFailed(withMsg: "Please fill in all fields above")
                return
        }
        
        // try to create user
        model = TodoModel()
        let (successful, message) = (model?.signup(username: signUpUsernameField.text!, password: signUpPasswordField.text!, passwordConf: signUpPasswordConfField.text!))!
        guard successful == true
            else {
                signUpFailed(withMsg: message)
                return
        }
        
        performSegue(withIdentifier: "notes", sender: nil)
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
