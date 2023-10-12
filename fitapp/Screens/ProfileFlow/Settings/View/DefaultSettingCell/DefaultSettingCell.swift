//
//  DefaultSettingCell.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

class DefaultSettingCell: UITableViewCell, Reusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: DefaultCellModel, disposeBag: DisposeBag) {
        self.titleLabel.text = model.type.title
        self.iconView.image = UIImage(named: model.type.image)
    }
}
