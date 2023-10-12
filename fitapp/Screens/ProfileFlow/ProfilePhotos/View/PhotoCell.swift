//
//  PhotoCell.swift
//  fitapp
//
//  Created by on 25.05.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct PhotoModelUrl {
    let uuid: String
    let imageUrl: String?
    
    var removeEnabledSubject = PublishSubject<Bool>()
    var removePhotoSubject = PublishSubject<Void>()
    var longPressSubject = PublishSubject<Void>()

    var url: URL? {
        if let urlString = imageUrl {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
}

class PhotoCell: CollectionViewCell {
    var isRemoveEnabled: Bool = true {
        didSet { self.removeButton.isHidden = !isRemoveEnabled }
    }
    
    private let containerView = UIView()
    
    private(set) var imageView = UIImageView()
    
    private let removeButton = UIButton()
    
    var model: PhotoModelUrl!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
    }
    
    override func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        imageView.backgroundColor = .lightGray
        
        removeButton.clipsToBounds = false
        removeButton.setImage(UIImage(named: "remove_photo_cell"), for: .normal)
    }
    
    override func setupConstraints() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(removeButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(20)
        }
    }
    
    func render(with model: PhotoModelUrl) {
        self.model = model
        
        if let urlString = model.imageUrl,
           let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
        
        let longTapGesture = UILongPressGestureRecognizer()
        imageView.addGestureRecognizer(longTapGesture)

        longTapGesture.rx.event
            .subscribe(onNext: { gesture in
                if gesture.state == .ended {
                    model.longPressSubject.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        model.removeEnabledSubject.asObservable()
            .subscribe(onNext: { isRemoveEnabled in
                self.removeButton.isHidden = !isRemoveEnabled
            })
            .disposed(by: disposeBag)

        removeButton.rx.tap.asObservable()
            .bind(to: model.removePhotoSubject)
            .disposed(by: disposeBag)

        removeButton.isHidden = true
    }
}
