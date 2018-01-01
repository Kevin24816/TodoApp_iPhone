//
//  NoteCell.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/31/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var TitleText: UILabel!
    
    @IBAction func editPressed(_ sender: UIButton) {
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
    }
    
    @IBAction func toggleCompleted(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
