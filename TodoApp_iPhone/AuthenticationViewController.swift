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
        
    }

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfField: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
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
        
        performSegue(withIdentifier: "notes", sender: nil)
        print("1")
    }
    
    @IBAction func signinPressed(_ sender: UIButton) {
        print("pressed signin")
        performSegue(withIdentifier: "notes", sender: nil)
        print("2")
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
