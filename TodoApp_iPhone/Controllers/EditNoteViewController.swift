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
    var preloadedNote: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextView!
    @IBOutlet weak var errorStatusLabel: UILabel!
    
    @IBOutlet weak var btnNoteAction: UIButton!
    @IBOutlet weak var btnExitEditor: UIButton!
    
    @IBAction func doneCreatingPressed(_ sender: UIButton) {
        guard let title = titleTextField.text, let details = detailsTextField.text else {
            return
        }
        
        guard !title.isEmpty, !details.isEmpty else {
            errorStatusLabel.text = "Please fill in the title and description."
            errorStatusLabel.isHidden = false
            return
        }
        
        if preloadedNote == nil {
            model?.addNote(withTitle: title, withDetail: details, viewCompletionHandler: closeEditorHandler(success:response:error:))
        } else {
            model?.editNote(onNoteID: (preloadedNote?.id)!, withTitle: title, withDetail: details, viewCompletionHandler: closeEditorHandler(success:response:error:))
        }
    }
    
    @IBAction func cancelActionPressed(_ sender: UIButton) {
        if preloadedNote == nil {
            performSegue(withIdentifier: "close editor", sender: nil)
        } else {
            model?.deleteNote(onNoteID: (preloadedNote?.id)!, viewCompletionHandler: closeEditorHandler(success:response:error:))
        }
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
            return
        }
        
        if let note = preloadedNote {
            titleTextField.text = note.title
            detailsTextField.text = note.detail
            btnNoteAction.setTitle("Save", for: .normal)
            btnExitEditor.setTitle("Delete", for: .normal)
        } else {
            btnNoteAction.setTitle("Save", for: .normal)
            btnExitEditor.setTitle("Discard", for: .normal)
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
