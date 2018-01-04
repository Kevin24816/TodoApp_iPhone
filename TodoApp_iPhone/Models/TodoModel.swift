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
    var serverModel = ServerModel()
    
    func login(username: String, password: String, completionHandler completion: @escaping (Bool, Any?, Error?) -> Void) {
        let url = URL(string: "http://TodoApp.test/auth")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = ["username": username, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json)
        } catch let error {
            print(error.localizedDescription)
        }
        
        serverModel.sendHTTPRequest(withRequest: request, getDataOn: ["username", "token"], completionHandler: completion)

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
    
//    private func makeRequest(withURLExtension ext: URL, withHTTPMethod method: String, withHeader header: [String: Any], withBody body: [String: Any]) -> URLRequest {
//
//    }
    private func sendRequest(withRequest request: URLRequest, returnDataOn dataKeys: [String]) -> (Int, [String: Any]) {
        return (0, [:])
    }
    
}
