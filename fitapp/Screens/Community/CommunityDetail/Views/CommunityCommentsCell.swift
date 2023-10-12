//
//  CommunityCommentsCell.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 14.06.2023.
//

import UIKit
import RxCocoa
import RxSwift

class CommunityCommentsCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var nestedView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    
    private var communityArticleModel: CommunityArticleCommentsModel!
    
    private var disposeBag = DisposeBag()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.roundCorners(radius: 4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configure(with model: CommunityArticleCommentsModel) {
        communityArticleModel = model
        dateLabel.text = model.model.timeLabel
        descriptionLabel.text = model.model.comments
        let role = model.model.modelAccount?.role?.capitalized
        typeLabel.text = role == "Trainer" ? role : .empty
        nameLabel.text = model.model.modelAccount?.name ?? ""
        
        updateLike(model.isLike, likes: model.likesCount)
        updateDislike(model.isDislike, dislikes: model.dislikeCount)
        
        nestedView.isHidden = !model.isNested
        separatorView.isHidden = !model.isNested
        bottomSeparatorView.isHidden = model.isNested
        
        guard let stringUrl = model.model.modelAccount?.avatar, let url = URL(string: stringUrl) else { return }
        userImage.kf.setImage(with: url)
        
        replyButton.rx.tap
            .bind(to: model.rx.replyTapEvent)
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .bind(to: model.rx.likeTapEvent)
            .disposed(by: disposeBag)
        
        dislikeButton.rx.tap
            .bind(to: model.rx.dislikeTapEvent)
            .disposed(by: disposeBag)
        
        model.likeChangedRelay
            .withUnretained(self)
            .subscribe { (`self`, isLike) in
                self.updateLike(isLike, likes: self.communityArticleModel.likesCount)
            }
            .disposed(by: disposeBag)
        
        model.dislikeChangedRelay
            .withUnretained(self)
            .subscribe { (`self`, isDislike) in
                self.updateDislike(isDislike, dislikes: self.communityArticleModel.dislikeCount)
            }
            .disposed(by: disposeBag)
    }
}

private extension CommunityCommentsCell {
    func updateLike(_ isLike: Bool, likes: Int) {
        let likesImage = isLike ? UIImage(named: "ThumbsUpRed") : UIImage(named: "ThumbsUp 1")
        likeButton.setImage(likesImage, for: .normal)
        likeButton.setTitle(likes == 0 ? "" : "\(likes)", for: .normal)
    }
    
    func updateDislike(_ isDislike: Bool, dislikes: Int) {
        let dislikesImage = isDislike ? UIImage(named: "ThumbsDownRed") : UIImage(named: "ThumbsDown 1")
        dislikeButton.setImage(dislikesImage, for: .normal)
        dislikeButton.setTitle(dislikes == 0 ? "" : "\(dislikes)", for: .normal)
    }
}
