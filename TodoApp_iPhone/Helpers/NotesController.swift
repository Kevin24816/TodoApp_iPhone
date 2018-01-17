import Foundation

class NotesController {
    static func addNote(withTitle title: String, withDetail detail: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = AccountHelper.getRequestHeader()
        let requestBody = ["title": title, "description": detail]
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes", withHTTPMethod: "POST", withRequestHeaders: requestHeader, withRequestBody: requestBody)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
    
    static func editNote(onNoteID id: Int, withTitle title: String, withDetail detail: String, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = AccountHelper.getRequestHeader()
        let requestBody = ["title": title, "description": detail]
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "PUT", withRequestHeaders: requestHeader, withRequestBody: requestBody)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
    
    static func deleteNote(onNoteID id: Int, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = AccountHelper.getRequestHeader()
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "DELETE", withRequestHeaders: requestHeader, withRequestBody: nil)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
    
    static func toggleCompleted(onNote id: Int, withCurrentState state: Bool, viewCompletionHandler viewHandler: @escaping (Bool, Any?, Error?) -> Void) {
        let requestHeader = AccountHelper.getRequestHeader()
        let requestBody = ["completed" : !state]
        
        print("changing state to \(!state) on note \(id)")
        let request = RequestHelper.makeHTTPRequest(withURLExt: "notes/\(id)", withHTTPMethod: "PUT", withRequestHeaders: requestHeader, withRequestBody: requestBody)
        
        RequestHelper.sendHTTPRequest(withRequest: request, getDataOn: ["id"], completionHandler: viewHandler)
    }
}
