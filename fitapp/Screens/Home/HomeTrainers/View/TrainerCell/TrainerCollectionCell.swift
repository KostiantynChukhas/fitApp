//
//  TrainerCollectionCell.swift
//  fitapp
//

//

import UIKit
import RxSwift

class TrainerCollectionCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trainerButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    private var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 12
        trainerButton.layer.cornerRadius = 14
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func render(with model: TrainerCollectionCellViewModel) {
        if let url = URL(string: model.trainer.avatar) {
            self.imageView.kf.setImage(with: url)
        }
        
        nameLabel.text = model.trainer.name
        likesCountLabel.text = String(model.trainer.modelTrainer.countLike)
        
        likeImage.rx.tapGesture().when(.recognized).mapToVoid()
            .bind(to: model.rx.likeTapEvent)
            .disposed(by: disposeBag)
        
        model.likeRelay.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, isLiked) in
                self.likeImage.image = isLiked ? UIImage(named: "ThumbsUpFilled"): UIImage(named: "ThumbsUpGold")
            }).disposed(by: disposeBag)
        
        model.likeCountRelay.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, likeCount) in
                self.likesCountLabel.text = "\(likeCount)"
            }).disposed(by: disposeBag)
    }

}
