//
//  EditNoteViewController.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/7/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {

    var model: TodoModel?
    var reloadNotesHandler: ((Bool, Any?, Error?) -> Void)?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextView!
    @IBOutlet weak var errorStatusLabel: UILabel!
    
    @IBAction func doneCreatingPressed(_ sender: UIButton) {
        guard let title = titleTextField.text, let details = detailsTextField.text else {
            return
        }
        
        guard !title.isEmpty, !details.isEmpty else {
            errorStatusLabel.text = "Please fill in the title and description."
            errorStatusLabel.isHidden = false
            return
        }
        
        model?.addNote(withTitle: title, withDetail: details, viewCompletionHandler: closeEditorHandler(success:response:error:))
    }
    
    private func closeEditorHandler(success: Bool, response: Any?, error: Error?) {
        if !success {
            print("error: server store notes failed. from: EditNoteViewController@closeEditorHandler. Trace: \(error!.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.reloadNotesHandler!(true, nil, nil)
            self.performSegue(withIdentifier: "close editor", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard model != nil, reloadNotesHandler != nil else {
            print("error: model not received. From: EditNoteViewController@viewDidLoad")
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noteVC = segue.destination as? NotesViewController {
            guard let todoModel = self.model else {
                print("error: todoModel not stored")
                return
            }
            
            noteVC.model = todoModel
        } else {
            print("error: notesVC was unable to be obtained in segue. from: EditNoteViewController@prepare(for segue)")
        }
    }

}
