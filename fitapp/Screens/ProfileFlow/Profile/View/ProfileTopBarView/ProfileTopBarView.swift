//
//  ProfileTopBarView.swift
//  fitapp
//
//  Created by on 21.05.2023.
//

import UIKit

@IBDesignable
class ProfileTopBarView: UIView {

    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
    }
    
    func set(alpha: CGFloat) {
        self.infoView.alpha = alpha
    }
    
    func setup(input: Input) {
        switch input.type {
        case .ownProfile:
            self.settingButton.setImage(UIImage(named: "GearSix"), for: .normal)
            self.editButton.setImage(UIImage(named: "PencilLine"), for: .normal)
        case .userProfile:
            self.settingButton.setImage(UIImage(named: "ic_back"), for: .normal)
            self.editButton.isHidden = true
        case .trainer:
            self.settingButton.setImage(UIImage(named: "ic_back"), for: .normal)
            self.editButton.setImage(UIImage(named: "Envelope"), for: .normal)
        }
    }
 
    struct Input {
        let type: ProfileType
    }
    
}
