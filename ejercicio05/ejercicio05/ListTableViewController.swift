

import UIKit

class ListTableViewController: UITableViewController {
    
    
    var songList = ["Radical Change", "Cigaro", "Ties That Bind", "Lija Y Terciopelo", "Moth Into Flame", "Nightmare"]
    var coverList = ["tremonti", "system", "alterBridge", "marea", "metallica", "avenged"]
    var titleList = ["Radical Change", "Cigaro", "Ties That Bind", "Lija Y Terciopelo", "Moth Into Flame", "Nightmare"]
    var authorList = ["Tremonti", "System of a down", "Alter Bridge", "Marea", "Metállica", "Avenged Sevenfold"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Funcion que activa y desactiva el estado de editar
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleList.count
    }
    
    //se le pasa a la celda los datos del titulo de la lista, la imagen de la portada, el grupo y el numero de la cancion en la lista para que los muestre en cada celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PersonalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PersonalTableViewCell
        cell.cellLabel.text = titleList[indexPath.row]
        cell.groupCellLabel.text = authorList[indexPath.row]
        cell.songNumberLabel.text = String(indexPath.row+1 )
        
        let coverSong = NSURL(fileURLWithPath: Bundle.main.path(forResource: coverList[indexPath.row], ofType: "jpg")!)
        let coverData = NSData(contentsOf: coverSong as URL)
        cell.coverView.image = UIImage(data: coverData! as Data)
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    //Funcion para borrar las canciones de la tabla, ya sea desde el modo edicion o arrastrando a la izquierda
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            songList.remove(at: indexPath.row)
            authorList.remove(at: indexPath.row)
            titleList.remove(at: indexPath.row)
            coverList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    //Funcion que permite reordenar las posiciones de la tabla desde el modo editar
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let titleMove = titleList[fromIndexPath.row]
        let songMove = songList[fromIndexPath.row]
        let authorMove = authorList[fromIndexPath.row]
        let coverMove = coverList[fromIndexPath.row]
        
        titleList.remove(at: fromIndexPath.row)
        songList.remove(at: fromIndexPath.row)
        authorList.remove(at: fromIndexPath.row)
        coverList.remove(at: fromIndexPath.row)
        
        titleList.insert(titleMove, at: to.row)
        songList.insert(songMove, at: to.row)
        authorList.insert(authorMove, at: to.row)
        coverList.insert(coverMove, at: to.row)
        
        tableView.reloadData()
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Variable de tipo ViewController
        let nextViewController: ViewController = segue.destination as! ViewController
        //Variable que recoge el index de la celda que se pulsa en la tabla y se lo pasa a indexSong del ViewController
        let indexPath = self.tableView.indexPathForSelectedRow
        
        //Datos que se le van a pasar al View Controller
        nextViewController.indexSong = indexPath?.row
        nextViewController.authorList = authorList
        nextViewController.coverList = coverList
        nextViewController.titleList = titleList
        nextViewController.songList = songList
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
