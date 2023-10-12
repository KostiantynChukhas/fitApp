//
//  AddPhotoCollectionCell.swift
//  fitapp
//
//  Created by  on 29.07.2023.
//

import UIKit
import RxCocoa
import RxSwift

class AddPhotoCollectionCell: CollectionViewCell {
    
    private let containerView = UIView()
    
    private let plusContainer = UIView()
    
    private let plusImageView = UIImageView()
    
    private let addPhotosLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 4
        plusContainer.layer.cornerRadius = 4
    }
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .white
        
        addPhotosLabel.minimumScaleFactor = 0.5
        addPhotosLabel.textColor = .black
        addPhotosLabel.font = Style.Font.latoMedium.uiFont.withSize(11)
        addPhotosLabel.textAlignment = .center
        
        plusContainer.backgroundColor = Style.Color.starship.uiColor
        plusImageView.image = UIImage(named: "plus_cell")
    }
    
    override func setupLocalization() {
        addPhotosLabel.text = "Add your photos"
    }
    
    override func setupConstraints() {
        addSubview(containerView)
     
        containerView.addSubview(plusContainer)
        containerView.addSubview(addPhotosLabel)
        
        plusContainer.addSubview(plusImageView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        plusContainer.snp.makeConstraints {
            $0.width.height.equalTo(46)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-12)
        }
        
        plusImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.center.equalToSuperview()
        }
        
        addPhotosLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalTo(plusContainer.snp.bottom).offset(14)
        }
        
    }
}
