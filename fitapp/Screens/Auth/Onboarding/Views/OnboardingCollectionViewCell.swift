//
//  OnboardingCollectionViewCell.swift
//Konstantin Chukhas on 12.12.2022.
//

import UIKit
import Kingfisher

class OnboardingCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet var imgView: GradientImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet weak var pageControll: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.startColor = UIColor(named: "GradientColor")?.withAlphaComponent(0) ?? .clear
        imgView.endColor = UIColor(named: "GradientColor") ?? .clear
        
    }
    
    func configure(with model: OnboardingData) {
        
        self.titleLabel.text = model.header
        self.descLabel.text = model.description
        
        let stringUrl = model.picture
        guard let stringEncode = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stringEncode) else { return }
        self.imgView.kf.setImage(with: url)
    }
}

