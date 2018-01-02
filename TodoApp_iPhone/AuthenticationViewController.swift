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
            if let token = apiToken {
                notesVC.apiToken = token
            }
        }
    }
    
    var apiToken: String?

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfField: UITextField!
    @IBOutlet weak var signinStatus: UILabel!
    @IBOutlet weak var signupStatus: UILabel!
    
    @IBAction func signupPressed(_ sender: UIButton) {
        guard emailField.text != "", passwordField.text != "", passwordConfField.text != ""
            else {
                signupStatus.text = "Please fill in all fields above"
                signupStatus.isHidden = false
                return
        }
        // try to create user
        
        apiToken = "temp"
        performSegue(withIdentifier: "notes", sender: nil)
    }
    
    @IBAction func signinPressed(_ sender: UIButton) {
        
        // authenticate with server
        apiToken = "temp"
        performSegue(withIdentifier: "notes", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
