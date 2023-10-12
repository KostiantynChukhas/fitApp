//
//  NotificationCell.swift
//  fitapp
//

//

import UIKit

class NotificationCell: UITableViewCell, Reusable {
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(with model: NotificationCellViewModel) {
        self.typeImageView.image = UIImage(named: model.type.imageName)
        self.typeLabel.text = model.type.title
        self.titleLabel.text = model.title
    }
    
}
