//
//  TodoModel.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/2/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import Foundation

class NetworkController {
    static func getRequestHeader() -> [String: String] {
        return ["Authorization": "Bearer \(AccountHelper.sharedInstance.getToken())"]
    }
    
    static func login(username: String, password: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestBody: [String: Any] = ["username": username, "password": password]
        let request = RequestHelper.makeHTTPRequest(withURLExt: "auth", withHTTPMethod: "POST", withRequestHeaders: nil, withRequestBody: requestBody)
        
        let completionHandler = authHandlerFactory(viewCompletionHandler: viewHandler)
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["username", "token"], completionHandler: completionHandler)
    }
    
    static func signup(username: String, password: String, passwordConf: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestBody: [String: Any] = ["username": username as Any, "password": password, "password_confirmation": passwordConf]
        let request = RequestHelper.makeHTTPRequest(withURLExt: "users", withHTTPMethod: "POST", withRequestHeaders: nil, withRequestBody: requestBody)
        
        let completionHandler = authHandlerFactory(viewCompletionHandler: viewHandler)
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["username", "token"], completionHandler: completionHandler)
    }
    
    static func signout(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = getRequestHeader()
        let request = RequestHelper.makeHTTPRequest(withURLExt: "auth", withHTTPMethod: "DELETE", withRequestHeaders: requestHeader, withRequestBody: nil)
        let completionHandler = signoutHandlerFactory(viewCompletionHandler: viewHandler)
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: [], completionHandler: completionHandler)
    }
    
    static func loadNotes(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = getRequestHeader()
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes", withHTTPMethod: "GET", withRequestHeaders: requestHeader, withRequestBody: nil)
        
        let completionHandler = loadNotesHandlerFactory(viewCompletionHandler: viewHandler)
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["notes"], completionHandler: completionHandler)
    }
    
    static func addNote(withTitle title: String, withDetail detail: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = getRequestHeader()
        let requestBody = ["title": title, "description": detail]
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes", withHTTPMethod: "POST", withRequestHeaders: requestHeader, withRequestBody: requestBody)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
    
    static func editNote(onNoteID id: Int, withTitle title: String, withDetail detail: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = getRequestHeader()
        let requestBody = ["title": title, "description": detail]
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "PUT", withRequestHeaders: requestHeader, withRequestBody: requestBody)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
    
    static func deleteNote(onNoteID id: Int, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = getRequestHeader()
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "DELETE", withRequestHeaders: requestHeader, withRequestBody: nil)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
    
    static func toggleCompleted(onNote id: Int, withCurrentState state: Bool, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = getRequestHeader()
        let requestBody = ["completed" : !state]
        
        print("changing state to \(!state) on note \(id)")
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "PUT", withRequestHeaders: requestHeader, withRequestBody: requestBody)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
    
    // Returns handler that updates the model as well as calls the view handler
    static private func authHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
        let completionHandler: (Bool, Any?, Error?) -> Void = {
            success, response, error in
            
            if !success {
                print("error: database failed. From: NetworkController@authHandlerFactory. Description: \(error!.localizedDescription)")
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
            
            AccountHelper.sharedInstance.username = username
            AccountHelper.sharedInstance.token = token

            viewHandler(true, nil, nil)
        }
        
        return completionHandler
    }
    
    // Handler that saves the new loaded notes as well as calls the view handler, which should update the view with the new notes.
    static private func loadNotesHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
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
            
            NotesStore.sharedInstance.notes.removeAll()

            // store the notes
            for noteItem in notes {
                let note = Note(withTitle: noteItem["title"] as! String,
                                withDetail: noteItem["description"] as! String,
                                withCompleted: noteItem["completed"] as! Bool,
                                withCreatedDate: noteItem["created_at"] as! String,
                                withID: noteItem["id"] as! Int)
                NotesStore.sharedInstance.notes.append(note)
            }

            viewHandler(true, nil, nil)
        }
        
        return completionHandler
    }
    
    static private func signoutHandlerFactory(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) -> ((Bool, Any?, Error?) -> Void) {
        let completionHandler: (Bool, Any?, Error?) -> Void = {
            success, response, error in
            
            if !success {
                print("error: database failed. From: TodoModel@signoutHandlerFactory. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }
            
            viewHandler(true, nil, nil)
            AccountHelper.sharedInstance.token = nil
            AccountHelper.sharedInstance.username = nil
            NotesStore.sharedInstance.notes = [Note]()
        }
        
        return completionHandler
    }

}
