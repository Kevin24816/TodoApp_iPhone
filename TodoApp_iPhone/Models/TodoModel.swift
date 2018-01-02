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
    let urlString = "https://todoapp24.herokuapp.com/"
    
    func login(username: String, password: String) -> (Bool, String) {
        let url = URL(string: urlString + "/auth")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var failed = false
        var statusMsg = ""
        var sessionUsername = ""
        var sessionToken = ""
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                statusMsg = error.debugDescription
                failed = true
                print(statusMsg)
            }
            
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    if let user = jsonData["username"] as? String {
                        sessionUsername = user
                        print("email: \(user)")
                    }
                    if let apiToken = jsonData["token"] as? String {
                        sessionToken = apiToken
                        print("token: \(apiToken)")
                    }
                    print("completed parsing")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
        
        if failed, sessionUsername == "" || sessionToken == "" {
            return (false, statusMsg)
        }
        
        apiToken = sessionToken
        self.username = sessionUsername
        // TODO: I NEED TO MAKE SURE REQUEST FINISHES LOADING BEFORE I MOVE ON
        // https://stackoverflow.com/questions/42705278/swift-url-session-and-url-request-not-working
        // learn about completion handlers
        print("request successful: username: \(self.username), token: \(apiToken)")
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
