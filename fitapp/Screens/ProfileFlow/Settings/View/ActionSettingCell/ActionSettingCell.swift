//
//  ActionSettingCell.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

class ActionSettingCell: UITableViewCell, Reusable {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: ActionCellModel, disposeBag: DisposeBag) {
        self.titleLabel.text = model.action.title
        self.titleLabel.textColor = model.action.color
        self.iconView.image = UIImage(named: model.action.image)?.withTintColor(model.action.color)
    }
    
}
