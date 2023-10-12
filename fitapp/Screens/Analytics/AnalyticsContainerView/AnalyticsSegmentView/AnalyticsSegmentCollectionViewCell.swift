//
//  AnalyticsSegmentCollectionViewCell.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AnalyticsSegmentCollectionViewCell: CollectionViewCell {
    
    func configure(vc: UIViewController) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(vc.view)
        vc.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }

}
