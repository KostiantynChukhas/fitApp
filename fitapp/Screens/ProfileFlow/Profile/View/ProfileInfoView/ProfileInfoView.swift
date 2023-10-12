//
//  ProfileInfoView.swift
//  fitapp
//
//  Created by on 21.05.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher

@IBDesignable
class ProfileInfoView: UIView {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarActionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = Style.Color.starship.uiColor.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
        profileImageView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
        profileImageView.backgroundColor = .lightGray
    }
    
    func setup(input: Input) {
        let isTrainer = input.type.isTrainer
        let isOwnProfile = input.type.isOwn
        
        containerView.isUserInteractionEnabled = isOwnProfile
        containerView.layer.borderWidth = isTrainer ? 0: 1
        avatarActionButton.isHidden = !isOwnProfile
        experienceLabel.isHidden = !isTrainer
        
        switch input.type {
        case .ownProfile(let user), .userProfile(model: let user):
            nameLabel.text = user.name ?? "N/A"
            setupAgeInfo(age: user.age)
            setupAvatar(avatar: user.avatar)
        case .trainer(let trainer):
            nameLabel.text = trainer.name
            experienceLabel.text = "Trainer experience: \(trainer.modelTrainer.trainerExperience)"
            setupTrainerAvatarSize()
            setupAvatar(avatar: trainer.avatar)
            infoLabel.isHidden = trainer.isInfoHidden
            infoLabel.text = trainer.infoLabelText
        }
    }
    
    private func setupAgeInfo(age: Int?) {
        infoLabel.isHidden = age == nil
        
        if let age = age {
            infoLabel.text = "\(age) years"
        }
    }
    
    private func setupTrainerAvatarSize() {
        widthConstraint.constant = 160
        heightConstraint.constant = 200
        layoutIfNeeded()
    }
    
    private func setupAvatar(avatar: String?) {
        if let avatar = avatar, !avatar.isEmpty, let url = URL(string: avatar) {
            profileImageView.contentMode = .scaleAspectFill
            avatarActionButton.setImage(UIImage(named: "ic_edit_photo"), for: .normal)
            profileImageView.kf.cancelDownloadTask()
            profileImageView.kf.setImage(
                with: url,
                options: [.forceRefresh, .diskCacheExpiration(.expired), .diskCacheExpiration(.expired)]
            )
        } else {
            profileImageView.contentMode = .center
            profileImageView.image = UIImage(named: "no_profile_image")
            avatarActionButton.setImage(UIImage(named: "ic_profile_add_picture"), for: .normal)
        }
    }
    
    func getOutput() -> Output {
        let output = Output(
            imageClicked: containerView.rx.tapGesture().when(.recognized).mapToVoid()
        )
        return output
    }
 
    struct Input {
        let type: ProfileType
    }
    
    struct Output {
        let imageClicked: Observable<Void>
    }
    
}
