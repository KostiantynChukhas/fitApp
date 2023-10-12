//
//  MainSegmentCollectionViewCell.swift
//  fitapp
//
//  Created by on 24.05.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainSegmentCollectionViewCell: CollectionViewCell {
    
    func configure(vc: UIViewController) {
        contentView.backgroundColor = .clear
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(vc.view)
        vc.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }

}
