//
//  Note.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/1/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import Foundation

struct Note {
    var title: String
    var detail: String
    var completed: Bool
    var createdDate: String
    
    init(withTitle title: String,
         withDetail detail: String,
         withCompleted completed: Bool,
         withCreatedDate createdDate: String) {
        self.title = title
        self.detail = detail
        self.completed = completed
        self.createdDate = createdDate
    }
    
    mutating func toggleCompleted() {
        if completed == false {
            completed = true
        } else {
            completed = false
        }
    }
    
    mutating func setTitle(title: String) {
        self.title = title
    }
    
    mutating func setDetail(detail: String) {
        self.detail = detail
    }
}
