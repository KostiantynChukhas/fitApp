//
//  ReviewPhotosCollectionView.swift
//  fitapp
//
//  Created by  on 29.07.2023.
//

import UIKit
import RxCocoa
import RxSwift

struct PhotoModel {
    let uuid: UUID
    let image: UIImage
}

class ReviewPhotosCollectionView: FitView {
    
    // MARK: - Observables
    
    public var collectionOffset: CGPoint = .zero {
        didSet {
            collectionView.contentOffset = collectionOffset
        }
    }
    
    private var isLoading = false
    
    private let disposeBag = DisposeBag()
    
    private(set) var addPhotoSubject = PublishSubject<Void>()
    
    private(set) var removePhotoSubject = PublishSubject<PhotoModel>()
    
    private var images: [PhotoModel] = []
    
    // MARK: - Properties
    
    private let containerView = UIView()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Setup
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 14
        layout.sectionInset = .zero
        
        let width = (UIScreen.main.bounds.width - 32 - 28) / 3
        layout.itemSize = .init(width: width, height: 102)
        layout.sectionInset = .zero
        
        return layout
    }()
    
    override func setupView() {
        clipsToBounds = false
        containerView.clipsToBounds = false
        collectionView.clipsToBounds = false
        
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.registerCellClass(AddPhotoCollectionCell.self)
        collectionView.registerCellClass(ReviewPhotoCollectionCell.self)
        
        collectionView.contentOffset = .zero
        collectionView.contentInset = .zero
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }

    override func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func render(images: Driver<[PhotoModel]>) {
        images.drive(onNext: { [weak self] in
            self?.images = $0
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
}

// MARK: - UICollectionViewDelegate

extension ReviewPhotosCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: .zero) - 1 {
            self.addPhotoSubject.onNext(())
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ReviewPhotosCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == collectionView.numberOfItems(inSection: .zero) - 1 {
            let cell = collectionView.dequeueReusableCell(ofType: AddPhotoCollectionCell.self, at: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(ofType: ReviewPhotoCollectionCell.self, at: indexPath)
            cell.render(with: images[indexPath.row])
            
            cell.removePhotoSubject.asObservable()
                .bind(to: removePhotoSubject)
                .disposed(by: disposeBag)
            
            return cell
        }
    }
}

