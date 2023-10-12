//
//  SettingHeaderCell.swift
//  fitapp
//
//  Created by on 24.05.2023.
//

import UIKit

class SettingHeaderCell: UITableViewCell, Reusable {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
