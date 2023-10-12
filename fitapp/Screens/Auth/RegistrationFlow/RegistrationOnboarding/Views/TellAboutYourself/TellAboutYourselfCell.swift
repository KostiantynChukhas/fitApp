//
//  TellAboutYourselfCell.swift
//  fitapp
//

import UIKit

protocol TellAboutYourselfDelegate: AnyObject {
    func getGenderType(from: String)
}

class TellAboutYourselfCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCheckList: UIView!
    weak var delegate: TellAboutYourselfDelegate?

    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    private var model: TellUsCellViewModel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configure(with: model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: TellUsCellViewModel) {
        self.model = model
        maleButton.isSelected = model.gender == .male
        femaleButton.isSelected = model.gender == .female
    }
    
    @IBAction func maleButtonActoin(_ sender: Any) {
        model.gender = .male
        maleButton.isSelected = true
        femaleButton.isSelected = false
    }
    
    @IBAction func femaleButtonAction(_ sender: Any) {
        model.gender = .female
        femaleButton.isSelected = true
        maleButton.isSelected = false
    }
}
