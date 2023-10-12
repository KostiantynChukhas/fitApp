//
//  DropDownCell.swift
//  fitapp
//
//  Created by Тетяна Нєізвєстна on 23.09.2023.
//

import UIKit

final class DropDownViewCell: UITableViewCell, Reusable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    func configure(with model: DropDownItem) {
        titleLabel.text = model.title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hexString: "#192126")
    }
}
