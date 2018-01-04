//
//  ServerModel.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/3/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import Foundation

class ServerModel {
    let urlAddress = "http://TodoApp.test/"
    var error = false
    var data = [String: String]()
    var statusMsg: String?
    var completed = false
    
    func makeHTTPRequest(withURLExt ext: String, withHTTPMethod method: String, withJsonHeader headerDict: [String: String]?, withJsonBody bodyDict: [String: Any]?) -> URLRequest {
        print("creating request")
        let url = URL(string: urlAddress + "http://TodoApp.test/auth")
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        if let jsonHeader = headerDict {
//            for key in jsonHeader.keys {
//                request.addValue(key, forHTTPHeaderField: jsonHeader[key]!)
//            }
//        }
        if let jsonBody = bodyDict {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
            } catch let error {
                print("request making error: " + error.localizedDescription)
            }
        }
        return request
    }
    
    func sendHTTPRequest(withRequest request: URLRequest, getDataOn dataKeys: [String], completionHandler completion: @escaping (Bool, Any?, Error?) -> Void) {
        print("sending request")
        URLSession.shared.dataTask(with: request) {
            data, response, error in
    
            if error != nil {
                print("error: \(error!.localizedDescription)")
                self.error = true
                self.statusMsg = error!.localizedDescription
            }
            
            guard let responseData = data else {
                print("error getting data")
                return
            }
            
            // parse json
            var sessionData = [String: String]()
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    print("parsing data: \(jsonData)")
                    
                    for key in dataKeys {
                        print("parsing item: \(key)")
                        // TODO: I should allow parsing all types of data here
                        if let item = jsonData[key] as? String {
                            print("parsed item: \(key) : \(item)")
                            sessionData[key] = item
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    print(sessionData)
                    completion(true, sessionData, nil)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
