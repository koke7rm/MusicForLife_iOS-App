
import UIKit

//Celda del TableView personalizada con una imagen que mostrara la imagen de la cancion y los labels que muestran el nombre de la cancion, el grupo y el numero de la cancion en la lista
class PersonalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var groupCellLabel: UILabel!
    @IBOutlet weak var songNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Se cambia el color del label de la celda
        cellLabel.textColor = UIColor .orange
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
