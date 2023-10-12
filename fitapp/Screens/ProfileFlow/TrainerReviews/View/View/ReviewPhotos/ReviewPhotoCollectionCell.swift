//
//  ReviewPhotoCollectionCell.swift
//  fitapp
//
//  Created by  on 29.07.2023.
//

import UIKit
import RxCocoa
import RxSwift

class ReviewPhotoCollectionCell: CollectionViewCell {
    
    var isRemoveEnabled: Bool = true {
        didSet { self.removeButton.isHidden = !isRemoveEnabled }
    }
    
    private(set) var removePhotoSubject = PublishSubject<PhotoModel>()
    
    private let containerView = UIView()
    
    private let imageView = UIImageView()
    
    private let removeButton = UIButton()
    
    var model: PhotoModel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
    }
    
    override func setupView() {
        clipsToBounds = false
        containerView.clipsToBounds = false
        
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        imageView.backgroundColor = .lightGray
     
        removeButton.clipsToBounds = false
        removeButton.setImage(UIImage(named: "remove_photo_cell"), for: .normal)
    }
    
    override func setupConstraints() {
        addSubview(containerView)
     
        containerView.addSubview(imageView)
        containerView.addSubview(removeButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(-10)
        }
    }
    
    func render(with model: PhotoModel) {
        self.model = model
        
        self.imageView.image = model.image
        
        self.removeButton.rx.tap.asObservable()
            .map { self.model }
            .bind(to: removePhotoSubject)
            .disposed(by: disposeBag)
    }
    
    func render(url: String, isEditable: Bool) {
        if let url = URL(string: url) {
            self.imageView.kf.setImage(with: url)
        }
        
        self.removeButton.isHidden = !isEditable
    }
}
