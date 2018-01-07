//
//  NotesViewController.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 12/31/17.
//  Copyright © 2017 Kevin Li. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [Note]()
    var model: TodoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todoModel = self.model {
            print("model received")
        }
        
//        // testing creation of cell
//        for i in 0..<5 {
//            let n = Note(title: "Note # \(String(i))", detail: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
//            notes += [n]
//        }
//        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        
        // create the cell here
        let note = notes[indexPath.row]

        cell.titleText.text = note.title
        cell.detailText.text = note.detail
        cell.btnCompleted.setTitle(note.completed == true ? "☑️" : "🔘", for: .normal)
        return cell
    }
    
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "signout", sender: nil)
    }
    
    @IBAction func addNotePressed(_ sender: UIBarButtonItem) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
