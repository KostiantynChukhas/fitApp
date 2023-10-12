//
//  TopSegmentCollectionViewCell.swift
//  fitapp
//
//  Created by on 24.05.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TopSegmentCollectionViewCell: CollectionViewCell {

    private let containerView = UIView()
    
    private let titleLabel = UILabel()

    override func layoutSubviews() {
        containerView.layoutIfNeeded()
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        titleLabel.font = Style.Font.latoBold.uiFont.withSize(14)
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-7)
        }
    }
    
    func setupOutput(_ viewModel: TopSegmentCollectionViewModelProtocol) {
        titleLabel.text = viewModel.title
        
        viewModel.isActive.asObservable().subscribe(onNext: { [weak self] value in
            self?.set(active: value)
        }).disposed(by: disposeBag)
    }
    
    func set(active: Bool) {
        self.containerView.backgroundColor = active ? .black: .white
        self.titleLabel.textColor = active ? .white: .black
    }
    
}
