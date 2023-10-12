//
//  DiscoverSearchCommunityTableViewCell.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 08.07.2023.
//

import UIKit
import Kingfisher

class DiscoverSearchCommunityTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: CommunityCellViewModel) {
        let model = item.model
        
        self.dateLabel.text = model.modelAccount?.timeLabel
        self.nameLabel.text = model.modelAccount?.name ?? ""
       
        if let files = item.model.files, let url = URL(string: files.first ?? "") {
            imgView.kf.setImage(with: url)
        }
       
    }
    
}
