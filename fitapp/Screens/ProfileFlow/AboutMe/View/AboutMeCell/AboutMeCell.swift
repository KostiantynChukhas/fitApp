//
//  AboutMeCell.swift
//  fitapp
//
//  Created by on 25.05.2023.
//

import UIKit

class AboutMeCell: UITableViewCell, Reusable {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(category: String, title: String) {
        self.mainLabel.text = category
        self.titleLabel.text = title
    }
    
}
