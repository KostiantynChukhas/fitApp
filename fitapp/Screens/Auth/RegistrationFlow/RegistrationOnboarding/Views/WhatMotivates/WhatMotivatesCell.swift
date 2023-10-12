//
//  WhatMotivatesCell.swift
//  fitapp
//

import UIKit

class WhatMotivatesCell: UICollectionViewCell {
    
    @IBOutlet weak var checkBoxView: UIView!
    
    @IBOutlet weak var feelingCheckBox: UIButton!
    @IBOutlet weak var beingNoticedCheckBox: UIButton!
    @IBOutlet weak var beingActiveCheckBox: UIButton!
    @IBOutlet weak var gainingCheckBox: UIButton!
    
    @IBOutlet weak var feelingView: UIView!
    @IBOutlet weak var beingNoticedView: UIView!
    @IBOutlet weak var beingActiveView: UIView!
    @IBOutlet weak var gainingView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var feelingTitleLabel: UILabel!
    @IBOutlet weak var beingNoticedTitleLabel: UILabel!
    @IBOutlet weak var beingActiveTitleLabel: UILabel!
    @IBOutlet weak var gainingTitleLabel: UILabel!
    
    @IBOutlet weak var feelingSubtitleLabel: UILabel!
    @IBOutlet weak var beingNoticedSubtitleLabel: UILabel!
    @IBOutlet weak var beingActiveSubtitleLabel: UILabel!
    @IBOutlet weak var gainingSubtitleLabel: UILabel!
    
    var model: WhatMotivatesCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let model = model {
            self.configure(with: model)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [feelingView, beingNoticedView, beingActiveView, gainingView].forEach {
            $0.roundCorners(radius: 12)
        }
    }
    
    func configure(with model: WhatMotivatesCellViewModel) {
        self.model = model
        updateUI()
        guard model.typeCell == .motivates else {
            titleLabel.text = "What’s your current activity level?"
            
            feelingTitleLabel.text = "Inactive"
            feelingSubtitleLabel.text = "Honestly, I’m not active at all."
            
            beingNoticedTitleLabel.text = "Moderately active"
            beingNoticedSubtitleLabel.text = "I work out on occasion but I want to step it up."
            
            beingActiveTitleLabel.text = "Active"
            beingActiveSubtitleLabel.text = "I work out often and it’s fairly big part of my life."
            
            gainingTitleLabel.text = "Very Active"
            gainingSubtitleLabel.text = "Text text text"
            
            return
        }
        
        titleLabel.text = "What motivates you the most?"
        
        feelingTitleLabel.text = "Feeling confident"
        feelingSubtitleLabel.text = "I want to be more confident in myself"
        
        beingNoticedTitleLabel.text = "Being noticed"
        beingNoticedSubtitleLabel.text = "I want to be respected, appreciated, and loved"
        
        beingActiveTitleLabel.text = "Being active"
        beingActiveSubtitleLabel.text = "I want to feel energetic, fit and healthy"
        
        gainingTitleLabel.text = "Gaining muscle"
        gainingSubtitleLabel.text = "I want to be and look stronger"
        
    }
    
    private func getImage(isSelected: Bool) -> UIImage {
        let image: UIImage = isSelected ? UIImage(named: "selected_radio_button") ?? UIImage() : UIImage(named: "unselected_radio_button") ?? UIImage()
        return image
    }
    
    private func updateUI() {
        guard let model = model else { return }
        
        feelingCheckBox.setImage(getImage(isSelected: false), for: .normal)
        beingNoticedCheckBox.setImage(getImage(isSelected: false), for: .normal)
        beingActiveCheckBox.setImage(getImage(isSelected: false), for: .normal)
        gainingCheckBox.setImage(getImage(isSelected: false), for: .normal)
        
        dismissAll()
        
        switch model.typeCell {
        case .motivates:
            feelingCheckBox.setImage(getImage(isSelected: model.type == .feelingConfident), for: .normal)
            beingNoticedCheckBox.setImage(getImage(isSelected: model.type == .beingNoticed), for: .normal)
            beingActiveCheckBox.setImage(getImage(isSelected: model.type == .beingActive), for: .normal)
            gainingCheckBox.setImage(getImage(isSelected: model.type == .gainingMuscle), for: .normal)
            
            switch model.type {
            case .feelingConfident:
                feelingView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .beingNoticed:
                beingNoticedView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .beingActive:
                beingActiveView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .gainingMuscle:
                gainingView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .none:
                dismissAll()
            }
            
        default:
            feelingCheckBox.setImage(getImage(isSelected: model.typeActivity == .inactive), for: .normal)
            beingNoticedCheckBox.setImage(getImage(isSelected: model.typeActivity == .moderatelyActive), for: .normal)
            beingActiveCheckBox.setImage(getImage(isSelected: model.typeActivity == .active), for: .normal)
            gainingCheckBox.setImage(getImage(isSelected: model.typeActivity == .veryActive), for: .normal)
            
            switch model.typeActivity {
            case .inactive:
                feelingView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .moderatelyActive:
                beingNoticedView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .active:
                beingActiveView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .veryActive:
                gainingView.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
            case .none:
                dismissAll()
            }
        }
    }
    
    private func dismissAll() {
        [feelingCheckBox, beingNoticedCheckBox,beingActiveCheckBox, gainingCheckBox].forEach {
            $0.isSelected = false
        }
        
        [feelingView, beingNoticedView, beingActiveView, gainingView].forEach {
            $0.addBorder(color: .clear, width: 1)
        }
    }
    
    @IBAction func feelingConfidentAction(_ sender: Any) {
        dismissAll()
        
        if model?.typeCell == .motivates {
            model?.type = .feelingConfident
        } else {
            model?.typeActivity = .inactive
        }
        
        updateUI()
    }
    @IBAction func beingAction(_ sender: Any) {
        dismissAll()
        
        if model?.typeCell == .motivates {
            model?.type = .beingNoticed
        } else {
            model?.typeActivity = .moderatelyActive
        }
        updateUI()
    }
    
    @IBAction func beingActiveAction(_ sender: Any) {
        dismissAll()
        
        if model?.typeCell == .motivates {
            model?.type = .beingActive
        } else {
            model?.typeActivity = .active
        }
        updateUI()
    }
    
    @IBAction func gainingAction(_ sender: Any) {
        dismissAll()
        
        if model?.typeCell == .motivates {
            model?.type = .gainingMuscle
        } else {
            model?.typeActivity = .veryActive
        }
        updateUI()
    }

}
