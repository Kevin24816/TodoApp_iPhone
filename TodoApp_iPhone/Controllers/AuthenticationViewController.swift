//
//  SignUpViewController.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/28/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    private var todoModel: TodoModel?

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
            signInStatus.text = "Please fill in all fields above"
            signInStatus.isHidden = false
            return
        }
        
        self.todoModel = TodoModel()
        self.todoModel!.login(username: username, password: password, viewCompletionHandler: authHandler(success:response:error:))
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        guard let username = signUpUsernameField.text, let password = signUpPasswordField.text, let password_conf = signUpPasswordConfField.text else {
            print("error: text fields are nil")
            return
        }
        
        guard !username.isEmpty, !password.isEmpty, !password_conf.isEmpty else {
            signUpStatus.text = "Please fill in all fields above"
            signUpStatus.isHidden = false
            return
        }
        
        self.todoModel = TodoModel()
        self.todoModel!.signup(username: username, password: password, passwordConf: password_conf, viewCompletionHandler: authHandler(success:response:error:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func authHandler(success: Bool, response: Any?, error: Error?) {
        if !success {
            print("error: authentication failed. from: AuthenticatinViewController@authHandler. Trace:\(error!.localizedDescription)")
            return
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "notes", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let notesVC = segue.destination as? NotesViewController {
            guard let todoModel = self.todoModel else {
                print("error: todoModel not stored")
                return
            }
            
            notesVC.model = todoModel
        } else {
            print("error: notesVC was unable to be obtained in segue. from: AuthenticationViewController@prepare(for segue)")
        }
    }
}
