//
//  DraftImageView.swift
//  fitapp
//
//  Created by Sergey Pritula on 14.08.2023.
//


import UIKit
import RxCocoa
import RxSwift

struct DraftModel {
    let id: String
    let url: String
}

class DraftImageView: FitView {
    
    private let containerView = UIView()
    
    private(set) var imageView = UIImageView()
    
    private(set) var removeButton = UIButton()
    
    private(set) var model: DraftModel?
    
    private(set) var removeImageSubject = PublishSubject<DraftModel>()
    
    private let disposeBag = DisposeBag()
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        imageView.backgroundColor = .lightGray
        
        clipsToBounds = false
        containerView.clipsToBounds = false
        
        isUserInteractionEnabled = true
        containerView.isUserInteractionEnabled = true
        
        removeButton.setImage(UIImage(named: "remove_photo_cell"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        removeButton.layer.cornerRadius = 12
    }
    
    override func setupConstraints() {
        addSubview(containerView)
     
        containerView.addSubview(imageView)
        containerView.addSubview(removeButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
    }
    
    func render(model: DraftModel) {
        self.model = model
        
        if !model.url.isEmpty, let url = URL(string: model.url) {
            imageView.kf.setImage(with: url)
        }
        
        removeButton.rx.tap.asObservable()
            .compactMap { self.model }
            .bind(to: removeImageSubject)
            .disposed(by: disposeBag)
    }
}
