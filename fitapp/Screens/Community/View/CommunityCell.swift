//
//  CommunityCell.swift
//  fitapp
//
//  on 14.05.2023.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class CommunityCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    var communityModel: CommunityCellViewModel!
    private var currentPage: Int = 0
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register([PhotoCommunityCollectionViewCell.identifier])
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.isPagingEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(with item: CommunityCellViewModel) {
        let model = item.model
        communityModel = item
        
        dateLabel.text = model.modelAccount?.timeLabel
        descriptionLabel.text = model.description
        nameLabel.text = model.modelAccount?.name ?? ""
        let role = model.modelAccount?.typeAccount?.capitalized
        typeLabel.text = role == "Trainer" ? role : .empty
        
        updateLike(communityModel.isLike, likes: communityModel.likesCount)
        updateDislike(communityModel.isDislike, dislikes: communityModel.dislikeCount)

        let comments = model.countComments ?? 0
        commentsButton.setTitle(comments == 0 ? "" : "\(comments)", for: .normal)
        
        collectionView.reloadData()
        
        likeButton.rx.tap
            .bind(to: item.rx.likeTapEvent)
            .disposed(by: disposeBag)
        
        dislikeButton.rx.tap
            .bind(to: item.rx.dislikeTapEvent)
            .disposed(by: disposeBag)
        
        commentsButton.rx.tap
            .bind(to: item.rx.commentTapEvent)
            .disposed(by: disposeBag)

        replyButton.rx.tap
            .bind(to: item.rx.shareTapEvent)
            .disposed(by: disposeBag)
        
        item.likeChangedRelay
            .withUnretained(self)
            .subscribe { (`self`, isLike) in
                self.communityModel.isLike = isLike
                self.updateLike(isLike, likes: self.communityModel.likesCount)
            }.disposed(by: disposeBag)
        
        item.dislikeChangedRelay
            .withUnretained(self)
            .subscribe { (`self`, isDislike) in
                self.communityModel.isDislike = isDislike
                self.updateDislike(isDislike, dislikes: self.communityModel.dislikeCount)
            }.disposed(by: disposeBag)
        
        pageControl.numberOfPages = communityModel.model.files?.count ?? 0
        pageControl.currentPage = 0
    }
}

extension CommunityCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communityModel.model.files?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCommunityCollectionViewCell = collectionView.dequeue(id: PhotoCommunityCollectionViewCell.self, for: indexPath)
        
        cell.imgView.image = nil
        if let files = communityModel.model.files, let url = URL(string: files[indexPath.row]) {
            cell.imgView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}


extension CommunityCell: UICollectionViewDelegate, UIScrollViewDelegate {
   
    func createLayout() -> UICollectionViewCompositionalLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Items
            let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            // Nested Group
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [smallItem])
            
            // Section
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            return section
        }
        
        return compositionalLayout
    }
}

private extension CommunityCell {
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
