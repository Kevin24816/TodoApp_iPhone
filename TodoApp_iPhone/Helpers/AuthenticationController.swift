import Foundation

class AuthenticationController {

    
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
        let requestHeader = AccountHelper.getRequestHeader()
        let request = RequestHelper.makeHTTPRequest(withURLExt: "auth", withHTTPMethod: "DELETE", withRequestHeaders: requestHeader, withRequestBody: nil)
        let completionHandler = signoutHandlerFactory(viewCompletionHandler: viewHandler)
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: [], completionHandler: completionHandler)
    }
    
    static func loadNotes(viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = AccountHelper.getRequestHeader()
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes", withHTTPMethod: "GET", withRequestHeaders: requestHeader, withRequestBody: nil)
        
        let completionHandler = loadNotesHandlerFactory(viewCompletionHandler: viewHandler)
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["notes"], completionHandler: completionHandler)
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
                print("error: incorrect data received from database. From: NetworkController@authHandlerFactory. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }
            
            guard let username = authData["username"], let token = authData["token"] else {
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
                print("error: database failed.From: NetworkController@loadNotesHandlerFactory. Description: \(error!.localizedDescription)")
                viewHandler(false, nil, error)
                return
            }

            guard let data = response as? [String: NSArray] else {
                print("error: failed to convert response From: NetworkController@loadNotesHandlerFactory.")
                return
            }
            
            guard let notes = data["notes"] as? [[String: Any]] else {
                print("error: failed to convert notes in response. From: NetworkController@loadNotesHandlerFactory.")
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
                print("error: database failed. From: NetworkController@loadNotesHandlerFactory. Description: \(error!.localizedDescription)")
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
