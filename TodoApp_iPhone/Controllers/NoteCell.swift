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
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var btnCompleted: UIButton!
    
    var getModel: (() -> TodoModel)?
    var delegate: CustomCellDelegator!
    var serverID: Int?
    var noteObj: Note?
    var completed: Bool? {
        didSet {
            if completed == true {
                titleView.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 0.7478328339)
                btnCompleted.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0.897260274)
                btnCompleted.setTitle("Undo", for: .normal)
            } else {
                titleView.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0.897260274)
                btnCompleted.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 0.7478328339)
                btnCompleted.setTitle("Complete", for: .normal)
            }
        }
    }
    
    @IBAction func editNotePressed(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate.callSegueFromCell(withCellData: noteObj)
        }
    }

    @IBAction func toggleCompletePressed(_ sender: UIButton) {
        let model = getModel!()
        model.toggleCompleted(onNote: (noteObj?.id)!, withCurrentState: completed!, viewCompletionHandler: toggleCompleteHandler(success:response:error:))
    }
    
    func toggleCompleteHandler(success: Bool, response: Any?, error: Error?) {
        if success {
            completed = !completed!
        } else {
            print("error from: NoteCell@toggleCompleteHandler")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
