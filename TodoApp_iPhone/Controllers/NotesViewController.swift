import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshNotes()
    }
    
    // Fetches the notes from the server and updates view with new notes.
    private func refreshNotes() {
        NetworkController.loadNotes(viewCompletionHandler: { (didUpdate, any, error) in
            if didUpdate {
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        NetworkController.signout(viewCompletionHandler: signoutHandler(success:response:error:))
    }
    
    @IBAction func addNotePressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "open editor", sender: nil)
    }
    


    func callSegueFromCell(withCellData dataobject: Any?) {
        self.performSegue(withIdentifier: "open editor", sender: dataobject)
    }


    //  TableView methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesStore.getNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        
        // create the cell from the note object stored in the model
        let note = NotesStore.getNotes()[indexPath.row]
        cell.configureWithNote(note: note)
        
        cell.completeButton.tag = indexPath.row
        cell.completeButton.addTarget(self, action: #selector(completedButtonPressedForCell(sender:)), for: .touchUpInside)
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editButtonPressedForCell(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func editButtonPressedForCell(sender: UIButton) {
        let note = NotesStore.sharedInstance.notes[sender.tag]
        performSegue(withIdentifier: "open editor", sender: note)
    }

    @objc func completedButtonPressedForCell(sender: UIButton) {
        //  use the tag to reference array index
        let note = NotesStore.sharedInstance.notes[sender.tag]
        NetworkController.toggleCompleted(onNote: note.id, withCurrentState: note.completed, viewCompletionHandler: { (didUpdate, any, error) in
            if didUpdate {
                NotesStore.sharedInstance.notes[sender.tag].completed = !note.completed
                self.tableView.reloadData()
            }
        })
    }
    
    // Segues back to sign in view once user is signed out
    private func signoutHandler(success: Bool, response: Any?, error: Error?) {
        if !success {
            print("error: server signout failed. from: NotesViewController@signoutHandler. Trace: \(error!.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "signout", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editorVC = segue.destination as? EditNoteViewController {
            editorVC.reloadNotesHandler = { (didUpdate, any, error) in
                if didUpdate {
                    self.tableView.reloadData()
                }
            }
            
            if let note = sender as? Note {
                editorVC.preloadedNote = note
            }
        }
    }
    
}
