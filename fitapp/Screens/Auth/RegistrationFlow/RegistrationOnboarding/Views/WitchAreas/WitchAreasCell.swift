//
//  WitchAreasCell.swift
//  fitapp
//

import UIKit

class WitchAreasCell: UICollectionViewCell {

    @IBOutlet weak var imgGender: UIImageView!
    
    @IBOutlet weak var btnArms: UIButton!
    @IBOutlet weak var btnChest: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAbs: UIButton!
    @IBOutlet weak var btnLegs: UIButton!
    @IBOutlet weak var btnFullBody: UIButton!
    
    @IBOutlet weak var chestTopConstraint: NSLayoutConstraint!
    private var buttons: [UIButton] = []

    private var model: TellAboutYourselfCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttons = [self.btnArms, self.btnChest, self.btnBack, self.btnAbs, self.btnLegs]
        
        btnFullBody.roundCorners(radius: 20)
        btnFullBody.addBorder(color: Style.Color.borderColor.uiColor, width: 2)
        setupUI()
    }
    
    func configure(with model: TellAboutYourselfCellViewModel) {
        self.model = model
        
        let gender = model.gender
        imgGender.image = UIImage(named: gender.rawValue )
        chestTopConstraint.constant = gender == .female ? 23 : 0
        setupUI()
        layoutIfNeeded()
    }
    
    private func setupUI() {
        let gender = model?.gender ?? .female
        let imgNameArms = btnArms.isSelected ? "\(gender)SelectedArms" : "\(gender)DeselectedArms"
        btnArms.setImage(UIImage(named: imgNameArms), for: .normal)

        let imgNameChest = btnChest.isSelected ? "\(gender)SelectedChest" : "\(gender)DeselectedChest"
        btnChest.setImage(UIImage(named: imgNameChest), for: .normal)

        let imgNameBack = btnBack.isSelected ? "\(gender)SelectedBack" : "\(gender)DeselectedBack"
        btnBack.setImage(UIImage(named: imgNameBack), for: .normal)

        let imgNameAbs = btnAbs.isSelected ? "\(gender)SelectedAbs" : "\(gender)DeselectedAbs"
        btnAbs.setImage(UIImage(named: imgNameAbs), for: .normal)

        let imgNameLegs = btnLegs.isSelected ? "\(gender)SelectedLegs" : "\(gender)DeselectedLegs"
        btnLegs.setImage(UIImage(named: imgNameLegs), for: .normal)
        
        let allSelected = buttons.allSatisfy { $0.isSelected }
        btnFullBody.setBackgroundColor(color: allSelected ? Style.Color.starship.uiColor : .white, forState: .normal)
    }
    
    @IBAction func btnFullBodyAction(_ sender: Any) {
        buttons.forEach {
            $0.isSelected = true
        }
        
        model?.type = BodyType.allCases
        setupUI()
    }
    
    @IBAction func btnArmsAction(_ sender: UIButton) {
        btnArms.isSelected = !btnArms.isSelected
        
        model?.type.removeAll(where: { $0 == .arms })
        
        if btnArms.isSelected {
            model?.type.append(.arms)
        }
        
        setupUI()
    }
    @IBAction func btnChestAction(_ sender: Any) {
        btnChest.isSelected = !btnChest.isSelected
        
        model?.type.removeAll(where: { $0 == .chest })
        
        if btnChest.isSelected {
            model?.type.append(.chest)
        }
        
        setupUI()
        
    }
    @IBAction func btnBackAction(_ sender: Any) {
        btnBack.isSelected = !btnBack.isSelected
        
        model?.type.removeAll(where: { $0 == .back })
        
        if btnBack.isSelected {
            model?.type.append(.back)
        }
        setupUI()
        
    }
    @IBAction func btnAbsAction(_ sender: Any) {
        btnAbs.isSelected = !btnAbs.isSelected
        
        model?.type.removeAll(where: { $0 == .abs })
        
        if btnAbs.isSelected {
            model?.type.append(.abs)
        }
        setupUI()
        
    }
    @IBAction func btnLegsAction(_ sender: Any) {
        btnLegs.isSelected = !btnLegs.isSelected
        
        model?.type.removeAll(where: { $0 == .legs })
        
        if btnLegs.isSelected {
            model?.type.append(.legs)
        }
        setupUI()
    }

}
