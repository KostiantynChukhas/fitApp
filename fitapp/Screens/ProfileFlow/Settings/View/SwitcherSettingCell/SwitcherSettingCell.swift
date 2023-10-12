//
//  SwitcherSettingCell.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

class SwitcherSettingCell: UITableViewCell, Reusable {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: SwitcherCellModel, disposeBag: DisposeBag) {
        self.titleLabel.text = model.type.title
        self.iconView.image = UIImage(named: model.type.image)
        self.switcher.isOn = model.isSelected
        
        switcher.rx.value.changed
            .bind(to: model.valueChanged)
            .disposed(by: disposeBag)
    }
}
