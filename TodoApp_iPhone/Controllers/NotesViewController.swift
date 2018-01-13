import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var model: TodoModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let model = self.model else {
            print("error: todo model not revceived from:NotesViewController@viewDidLoad()")
            return
        }

        // loads the notes for the user
        model.loadNotes(viewCompletionHandler: reloadNotesHandler(success:response:error:))
    }
    
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        model?.signout(viewCompletionHandler: signoutHandler(success:response:error:))
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
        return model!.getNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        
        // create the cell from the note object stored in the model
        let note = model!.getNotes()[indexPath.row]
        cell.configureWithNote(note: note)
        cell.btnCompleted.tag = indexPath.row

        cell.btnCompleted.addTarget(self, action: #selector(completedButtonPressedForCell(sender:)), for: .touchUpInside)
        return cell
    }

    @objc func completedButtonPressedForCell(sender: UIButton) {
        //  use the tag to reference array index
        let note = model!.getNotes()[sender.tag]
        model?.toggleCompleted(onNote: note.id, withCurrentState: note.completed, viewCompletionHandler: { (didUpdate, any, error) in
            
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
