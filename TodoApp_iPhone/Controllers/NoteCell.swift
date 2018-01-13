//
//  NoteCell.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/31/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnCompleted: UIButton!

    //  This only runs once, so add styles that don't change here
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
    }

    func configureWithNote(note: Note) {
        self.titleView.backgroundColor = note.completed ?  #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 0.7478328339) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0.897260274)
        self.btnCompleted.backgroundColor = note.completed ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0.897260274) : #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 0.7478328339)
        let title = note.completed ? "Complete" : "Undo"
        self.btnCompleted.setTitle(title, for: .normal)
        self.titleLabel.text = note.title
        self.detailTextView.text = note.detail
    }
}
