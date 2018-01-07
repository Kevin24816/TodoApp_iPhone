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
    
    func login(username: String, password: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let jsonBody: [String: Any] = ["username": username, "password": password]
        let request = ServerModel.makeHTTPRequest(withURLExt: "auth", withHTTPMethod: "POST", withJsonHeader: nil, withJsonBody: jsonBody)
        
        let completionHandler = authHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["username", "token"], completionHandler: completionHandler)
    }
    
    func signup(username: String, password: String, passwordConf: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let jsonBody: [String: Any] = ["username": username, "password": password, "password_confirmation": passwordConf]
        let request = ServerModel.makeHTTPRequest(withURLExt: "users", withHTTPMethod: "POST", withJsonHeader: nil, withJsonBody: jsonBody)
        
        let completionHandler = authHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["username", "token"], completionHandler: completionHandler)
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
    
    private func authHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> (Bool, Any?, Error?) -> Void {
        
        let completionHandler: (Bool, Any?, Error?) -> Void = {
            success, response, error in
            
            if !success {
                print("error: database failed. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }
            
            guard let authData = response as? [String: String] else {
                print("error: incorrect data received from database. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }
            
            guard let username = authData["username"], let token = authData["token"] else {
                print("error: incorrect data was receved from http response")
                return
            }
            
            self.username = username
            self.apiToken = token
            viewHandler(true, nil, nil)
        }
        
        return completionHandler
    }
    
    private func sendRequest(withRequest request: URLRequest, returnDataOn dataKeys: [String]) -> (Int, [String: Any]) {
        return (0, [:])
    }
    
}
