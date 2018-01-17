//
//  EditNoteViewController.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/7/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {

    var reloadNotesHandler: ((Bool, Any?, Error?) -> Void)?
    var preloadedNote: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextView!
    @IBOutlet weak var errorStatusLabel: UILabel!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
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
        
        // check if this segue is for editing or making a new note
        if preloadedNote == nil {
            NetworkController.addNote(withTitle: title, withDetail: details, viewCompletionHandler: closeEditorHandler(success:response:error:))
        } else {
            NetworkController.editNote(onNoteID: (preloadedNote?.id)!, withTitle: title, withDetail: details, viewCompletionHandler: closeEditorHandler(success:response:error:))
        }
    }
    
    @IBAction func cancelActionPressed(_ sender: UIButton) {
        if preloadedNote == nil {
            performSegue(withIdentifier: "close editor", sender: nil)
        } else {
            NetworkController.deleteNote(onNoteID: (preloadedNote?.id)!, viewCompletionHandler: closeEditorHandler(success:response:error:))
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
        
        guard reloadNotesHandler != nil else {
            return
        }
        
        // customize keyboard hiding
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneTyping))
        toolbar.setItems([doneButton], animated: false)
        toolbar.sizeToFit()
        titleTextField.inputAccessoryView = toolbar
        detailsTextField.inputAccessoryView = toolbar
        
        // check if this segue is for editing or making a new note
        if let note = preloadedNote {
            navigationTitle.title = "Edit Note"
            titleTextField.text = note.title
            detailsTextField.text = note.detail
            btnNoteAction.setTitle("Save", for: .normal)
            btnExitEditor.setTitle("Delete", for: .normal)
        } else {
            navigationTitle.title = "Create Note"
            btnNoteAction.setTitle("Save", for: .normal)
            btnExitEditor.setTitle("Discard", for: .normal)
        }
    }
    
    @objc func doneTyping() {
        view.endEditing(true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

}
