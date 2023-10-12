//
//  WatsYourNameCell.swift
//  fitapp
//
// on 04.05.2023.
//

import UIKit

class WatsYourNameCell: UICollectionViewCell {

    @IBOutlet weak var textField: UITextField!
    private var model: WhatsYourNameCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func configure(with model: WhatsYourNameCellViewModel) {
        self.model = model
        self.textField.text = model.name
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let name = textField.text else { return }
        self.model?.name = name
    }
}
