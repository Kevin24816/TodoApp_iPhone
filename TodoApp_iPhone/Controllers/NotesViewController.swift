//
//  NotesViewController.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/31/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegator {
    
    func callSegueFromCell(withCellData dataobject: Any?) {
        self.performSegue(withIdentifier: "open editor", sender: dataobject)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    @IBOutlet weak var tableView: UITableView!
    var model: TodoModel?
    
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        model?.signout(viewCompletionHandler: signoutHandler(success:response:error:))
    }
    
    @IBAction func addNotePressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "open editor", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = self.model else {
            print("error: todo model not revceived from:NotesViewController@viewDidLoad()")
            return
        }
        
        // loads the notes for the user
        model.loadNotes(viewCompletionHandler: reloadNotesHandler(success:response:error:))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model!.getNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        
        // create the cell here
        let note = model!.getNotes()[indexPath.row]
        cell.getModel = getTodoModel
        cell.titleText.text = note.title
        cell.detailText.text = note.detail
        cell.completed = note.completed
        cell.noteObj = note
        cell.delegate = self
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        return cell
    }
    
    private func signoutHandler(success: Bool, response: Any?, error: Error?) {
        if !success {
            print("error: server signout failed. from: NotesViewController@signoutHandler. Trace: \(error!.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "signout", sender: nil)
        }
    }
    
    /*
     Reloads the notes for the user.
     */
    private func reloadNotesHandler(success: Bool, response: Any?, error: Error?) {
        if !success {
            print("error: reload notes handler failed. from: NotesViewController@loadNotesHandler. Trace:\(error!.localizedDescription)")
            return
        }
        tableView.reloadData()
    }
    
    private func getTodoModel() -> TodoModel {
        return model!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoModel = self.model
        if let editorVC = segue.destination as? EditNoteViewController, let note = sender as? Note {
            editorVC.model = todoModel
            editorVC.reloadNotesHandler = reloadNotesHandler(success:response:error:)
            editorVC.preloadedNote = note
        } else if let editorVC = segue.destination as? EditNoteViewController {
            editorVC.model = todoModel
            editorVC.reloadNotesHandler = reloadNotesHandler(success:response:error:)
        }
    }
    
}
