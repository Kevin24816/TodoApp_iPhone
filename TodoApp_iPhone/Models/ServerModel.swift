//
//  ServerModel.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/3/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import Foundation

class ServerModel {
    static let urlAddress = "http://TodoApp.test/"
    
    static func makeHTTPRequest(withURLExt ext: String, withHTTPMethod method: String, withJsonHeader headerDict: [String: String]?, withJsonBody bodyDict: [String: Any]?) -> URLRequest {
        let url = URL(string: urlAddress + ext)
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonBody = bodyDict {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
            } catch let error {
                print(error.localizedDescription)
            }
        }

        return request
    }
    
    static func sendHTTPRequest(withRequest request: URLRequest, getDataOn dataKeys: [String], completionHandler completion: @escaping (Bool, Any?, Error?) -> Void) {
        print("sending request")
        URLSession.shared.dataTask(with: request) {
            data, response, error in
    
            if error != nil {
                print("error: \(error!.localizedDescription)")
            }
            
            guard let responseData = data else {
                print("error getting data")
                return
            }
            
            // parse json
            var sessionData = [String: String]()
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    
                    for key in dataKeys {
                        // TODO: I should allow parsing all types of data here
                        if let item = jsonData[key] as? String {
                            sessionData[key] = item
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    print("parsed session data: \(sessionData)")
                    completion(true, sessionData, nil)
                }
            } catch let error as NSError {
                print("error: \(error.localizedDescription); FROM(sendHTTPRequest in ServerModel)")
            }
        }.resume()
    }
    
}
