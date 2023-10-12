//
//  TrainerReviewCell.swift
//  fitapp
//
//  Created by  on 03.08.2023.
//

import UIKit

class TrainerReviewCell: TableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var rateView: RateStarsView!
    @IBOutlet weak var photosCollection: UICollectionView!
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .zero
        
        let width = (self.bounds.width - 24 - 16) / 3.5
        layout.itemSize = .init(width: width, height: 80)
        layout.sectionInset = .zero
        
        return layout
    }()
    
    private var photos: [String] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 12
        authorImageView.layer.cornerRadius = 6
        authorImageView.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.photosCollection.registerCellClass(ReviewPhotoCollectionCell.self)
        self.photosCollection.collectionViewLayout = layout
        self.photosCollection.dataSource = self
        self.authorImageView.contentMode = .scaleAspectFill
    }
    
    func render(model: TrainerReviewData) {
        self.photosCollection.isHidden = model.picture?.isEmpty ?? true
        self.rateView.stars = model.star
        self.reviewLabel.text = model.description
        self.authorName.text = model.modelAccount.name ?? "Unknown user"
        self.dateLabel.text = model.date
        
        if let avatar = model.modelAccount.avatar, let url = URL(string: avatar) {
            authorImageView.kf.setImage(with: url)
        }
        
        self.photos = model.picture?.compactMap { $0 } ?? []
        self.photosCollection.reloadData()
    }
    
}

extension TrainerReviewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: ReviewPhotoCollectionCell.self, at: indexPath)
        cell.render(url: photos[indexPath.row], isEditable: false)
        return cell
    }
}
