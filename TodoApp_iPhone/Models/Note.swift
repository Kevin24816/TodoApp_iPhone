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
    var completed = false
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
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
