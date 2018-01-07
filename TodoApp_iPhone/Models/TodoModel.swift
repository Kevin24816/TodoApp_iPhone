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
        let requestBody: [String: Any] = ["username": username, "password": password]
        let request = ServerModel.makeHTTPRequest(withURLExt: "auth", withHTTPMethod: "POST", withRequestHeaders: nil, withRequestBody: requestBody)
        
        let completionHandler = authHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["username", "token"], completionHandler: completionHandler)
    }
    
    func signup(username: String, password: String, passwordConf: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestBody: [String: Any] = ["username": username, "password": password, "password_confirmation": passwordConf]
        let request = ServerModel.makeHTTPRequest(withURLExt: "users", withHTTPMethod: "POST", withRequestHeaders: nil, withRequestBody: requestBody)
        
        let completionHandler = authHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["username", "token"], completionHandler: completionHandler)
    }
    
    func loadNotes(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeaders = ["Authorization": "Bearer \(apiToken!)"]
        let request = ServerModel.makeHTTPRequest(withURLExt: "notes", withHTTPMethod: "GET", withRequestHeaders: requestHeaders, withRequestBody: nil)
        
        let completionHandler = loadNotesHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["notes"], completionHandler: completionHandler)
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
    
    private func authHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
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
    
    private func loadNotesHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
        let completionHandler: (Bool, Any?, Error?) -> Void = {
            success, response, error in
            
            if !success {
                print("error: database failed. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }
            
//            guard let authData = response as? [String: String] else {
//                print("error: incorrect data received from database. Description: \(error!.localizedDescription)")
//                viewHandler(false, nil, error)
//                return
//            }
            

            
            // TODO: store the notes
            guard let data = response as? [String: NSArray] else {
                print("error: failed to convert response from: TodoModel@loadNotesHandlerFactory")
                return
            }
            
            guard let notes = data["notes"] as? [[String: Any]] else {
                print("error: failed to convert notes in response from: TodoModel@loadNotesHandlerFactory")
                return
            }
            
            for noteItem in notes {
                var note = Note(withTitle: noteItem["title"] as! String,
                                withDetail: noteItem["description"] as! String,
                                withCreatedDate: noteItem["created_at"] as! String,
                                withServerID: noteItem["id"] as! String,
                                withCompleted: noteItem["completed"] as! Bool
                )
                self.notes += note
            }

            viewHandler(true, nil, nil)
        }
        
        return completionHandler
    }
    
    func getNotes() -> [Note] {
        return notes
    }
}
