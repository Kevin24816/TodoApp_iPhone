//
//  NotesStore.swift
//  TodoApp_iPhone
//
//  Created by Trey Villafane on 1/12/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import Foundation

class NotesStore {
    public static var sharedInstance = NotesStore()
    var notes: [Note] = []
    
    fileprivate init() {
        
    }
    
    static func getNotes() -> [Note] {
        return NotesStore.sharedInstance.notes
    }
}
