//
//  LibraryArticleRowsCommentsCell.swift
//  fitapp
//
//  on 14.05.2023.
//

import UIKit
import RxCocoa
import RxSwift

class LibraryArticleRowsCommentsCell: UITableViewCell, Reusable {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionReplyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameReplyLabel: UILabel!

    @IBOutlet weak var typeImgView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var nestedView: UIView!
    @IBOutlet weak var replyView: UIView!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configure(with model: LibraryArticleCommentsModel, disposeBag: DisposeBag) {
        self.dateLabel.text = model.commentsModel.timeLabel
        self.descriptionLabel.text = model.commentsModel.comments
        let role = model.commentsModel.modelAccount?.role?.capitalized
        self.typeLabel.text = role == "Trainer" ? role : .empty
        self.nameLabel.text = model.commentsModel.modelAccount?.name ?? ""
        self.typeImgView.isHidden = role != "Trainer"
       
        nestedView.isHidden = !model.isNested
        topSeparatorView.isHidden = model.isNested
        replyView.isHidden = !model.isNested
        
        nameReplyLabel.text = model.nestedName
        descriptionReplyLabel.text = model.nestedComment
        
        if let stringUrl = model.commentsModel.modelAccount?.avatar, let url = URL(string: stringUrl) {
            userImage.kf.setImage(with: url)
        }
        
        updateLike(model.isLike, likes: model.likesCount)
        updateDislike(model.isDislike, dislikes: model.dislikeCount)
        
        replyButton.rx.tap
            .bind(to: model.rx.replyTapEvent)
            .disposed(by: disposeBag)
        
        moreButton.rx.tap
            .bind(to: model.rx.moreTapEvent)
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
                model.isLike = isLike
                self.updateLike(isLike, likes: model.likesCount)
            }.disposed(by: disposeBag)
        
        model.dislikeChangedRelay
            .withUnretained(self)
            .subscribe { (`self`, isDislike) in
                model.isDislike = isDislike
                self.updateDislike(isDislike, dislikes: model.dislikeCount)
            }.disposed(by: disposeBag)
    }
}

private extension LibraryArticleRowsCommentsCell {
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
