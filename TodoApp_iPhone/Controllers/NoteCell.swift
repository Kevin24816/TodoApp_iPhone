//
//  NoteCell.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/31/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    var getModel: (() -> TodoModel)?
    var delegate: CustomCellDelegator!
    
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var btnCompleted: UIButton!
    
    
    
//    if(self.delegate != nil){ //Just to be safe.
//        self.delegate.callSegueFromCell(withCellData: nil)
//    }
    
    @IBAction func toggleCompletedPressed(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // TODO: how to segue from table view cell??
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let editorVC = segue.destination as? EditNoteViewController {
//            guard let todoModel = self.model else {
//                print("error: todoModel not stored")
//                return
//            }
//
//            editorVC.model = todoModel
//            editorVC.reloadNotesHandler = reloadNotesHandler(success:response:error:)
//        }
//    }
    
}
