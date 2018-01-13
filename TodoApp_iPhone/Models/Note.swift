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
    var createdDate: String?
    var id: Int
    
    init(withTitle title: String,
         withDetail detail: String,
         withCompleted completed: Bool,
         withCreatedDate createdDate: String,
         withID id: Int) {
        self.title = title
        self.detail = detail
        self.completed = completed
        self.createdDate = createdDate
        self.id = id
    }
}
