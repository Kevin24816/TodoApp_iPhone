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
    
    func signout(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeaders = ["Authorization": "Bearer \(apiToken!)"]
        let request = ServerModel.makeHTTPRequest(withURLExt: "auth", withHTTPMethod: "DELETE", withRequestHeaders: requestHeaders, withRequestBody: nil)
        let completionHandler = signoutHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: [], completionHandler: completionHandler)
    }
    
    func loadNotes(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeaders = ["Authorization": "Bearer \(apiToken!)"]
        let request = ServerModel.makeHTTPRequest(withURLExt: "notes", withHTTPMethod: "GET", withRequestHeaders: requestHeaders, withRequestBody: nil)
        
        let completionHandler = loadNotesHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["notes"], completionHandler: completionHandler)
    }
    
    func addNote(withTitle title: String, withDetail detail: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeaders = ["Authorization": "Bearer \(apiToken!)"]
        let requestBody = ["title": title, "description": detail]
        let request = ServerModel.makeHTTPRequest(withURLExt: "notes", withHTTPMethod: "POST", withRequestHeaders: requestHeaders, withRequestBody: requestBody)
        
        let completionHandler = saveNoteHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: completionHandler)
    }
    
    func editNote(onNoteID id: Int, withTitle title: String, withDetail detail: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeaders = ["Authorization": "Bearer \(apiToken!)"]
        let requestBody = ["title": title, "description": detail]
        let request = ServerModel.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "PUT", withRequestHeaders: requestHeaders, withRequestBody: requestBody)
        
        let completionHandler = saveNoteHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: completionHandler)
    }
    
    func deleteNote(onNoteID id: Int, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeaders = ["Authorization": "Bearer \(apiToken!)"]
        let request = ServerModel.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "DELETE", withRequestHeaders: requestHeaders, withRequestBody: nil)
        
        let completionHandler = saveNoteHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: completionHandler)
    }
    
    func toggleCompleted(onNote id: Int, withCurrentState state: Bool, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeaders = ["Authorization": "Bearer \(apiToken!)"]
        let requestBody = ["completed" : !state]
        let request = ServerModel.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "PUT", withRequestHeaders: requestHeaders, withRequestBody: requestBody)
        
        let completionHandler = saveNoteHandlerFactory(viewCompletionHandler: viewHandler)
        ServerModel.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: completionHandler)
    }
    
    // Returns handler that updates the model as well as calls the view handler
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
    
    private func saveNoteHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
        let completionHandler: (Bool, Any?, Error?) -> Void = {
            success, response, error in
            if success {
                viewHandler(true, nil, nil)
            } else {
                viewHandler(false, nil, error)
            }
        }
        
        return completionHandler
    }
    
    // Handler that saves the new loaded notes as well as calls the view handler, which should update the view with the new notes.
    private func loadNotesHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
        let completionHandler: (Bool, Any?, Error?) -> Void = {
            success, response, error in
            
            if !success {
                print("error: database failed. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }

            guard let data = response as? [String: NSArray] else {
                print("error: failed to convert response from: TodoModel@loadNotesHandlerFactory")
                return
            }
            
            guard let notes = data["notes"] as? [[String: Any]] else {
                print("error: failed to convert notes in response from: TodoModel@loadNotesHandlerFactory")
                return
            }
            
            self.notes.removeAll()
            // store the notes
            for noteItem in notes {
                let note = Note(withTitle: noteItem["title"] as! String,
                                withDetail: noteItem["description"] as! String,
                                withCompleted: noteItem["completed"] as! Bool,
                                withCreatedDate: noteItem["created_at"] as! String,
                                withID: noteItem["id"] as! Int)
                self.notes.append(note)
            }

            viewHandler(true, nil, nil)
        }
        
        return completionHandler
    }
    
    private func signoutHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
        let completionHandler: (Bool, Any?, Error?) -> Void = {
            success, response, error in
            
            if !success {
                print("error: database failed. From: TodoModel@signoutHandlerFactory. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }
            
            viewHandler(true, nil, nil)
            self.apiToken = nil
            self.username = nil
            self.notes = [Note]()
        }
        
        return completionHandler
    }
    
    func getNotes() -> [Note] {
        return notes
    }
}
