//
//  TodoModel.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/2/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import Foundation

class TodoModel {
    
    var apiToken: String?
    var username: String?
    var notes = [Note]()
    let urlString = "http://TodoApp.test/"
    
    func login(username: String, password: String) -> (Bool, String) {
        let url = URL(string: "http://TodoApp.test/auth")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let json: [String: Any] = ["username": username, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json)
        } catch let error {
            print(error.localizedDescription)
        }
        
        print("sending sign in request with username: \(username) and password \(password)")
        
        var failed = false
        var statusMsg = ""
        var sessionUsername = ""
        var sessionToken = ""
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                failed = true
                statusMsg = error!.localizedDescription
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    print(jsonData)
                    if let user = jsonData["username"] as? String, let token = jsonData["token"] as? String {
                        sessionUsername = user
                        sessionToken = token
                    }
                    
                    DispatchQueue.main.async {
                        self.username = sessionUsername
                        self.apiToken = sessionToken
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
        
        if failed, sessionUsername == "" || sessionToken == "" {
            print("request failed")
            return (false, statusMsg)
        }
        
        return (true, "")
    }
    
    func signup(username: String, password: String, passwordConf: String) -> (Bool, String) {
        return (true, "")
    }
    
    func addNote(withTitle title: String, withDetail detail: String) {
        
    }
    
    func editNote(onNote id: Int, withTitle title: String?, withDetail detail: String?) {
        if let t = title {
            notes[id].title = t
        }
        
        if let d = detail {
            notes[id].detail = d
        }
    }
    
    func toggleCompleted(onNote id: Int) {
        notes[id].toggleCompleted()
    }
    
    init() {
        
    }
    
}
