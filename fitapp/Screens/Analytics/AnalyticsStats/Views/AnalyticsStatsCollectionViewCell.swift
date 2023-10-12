//
//  AnalyticsStatsCollectionViewCell.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 14.08.2023.
//

import UIKit

class AnalyticsStatsCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        generalView.roundCorners(radius: 12)
        generalView.addBorder(color: UIColor(red: 0.098, green: 0.129, blue: 0.149, alpha: 1), width: 1)
    }
    
    func configure(with model: AnalyticsStatsPeriod) {
        imgView.image = UIImage(named: model.image)
        titleLabel.text = model.title
        descLabel.text = model.description
    }

}
