//
//  HomeSegmentCollectionViewCell.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeSegmentCollectionViewCell: CollectionViewCell {
    
    func configure(vc: UIViewController) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(vc.view)
        vc.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }

}
