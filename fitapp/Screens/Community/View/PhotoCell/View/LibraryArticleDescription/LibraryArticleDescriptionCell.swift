//
//  LibraryArticleDescriptionCell.swift
//  fitapp
//
//  on 14.05.2023.
//

import UIKit
import Kingfisher

class LibraryArticleDescriptionCell: UITableViewCell, Reusable {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
//        let topColor1 = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 0.5080782313)
//        let topColor2 = #colorLiteral(red: 0.09803921569, green: 0.1294117647, blue: 0.1490196078, alpha: 0.2164647109)
//        let topColor3 = #colorLiteral(red: 0.09803921569, green: 0.1294117647, blue: 0.1490196078, alpha: 0.1963754252)
//        topView.addGradientLayer(colors: [topColor1, topColor2, topColor3], locations: [0.0, 0.5, 1.0], startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
//
//        let bottomColor1 = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9803921569, alpha: 0)
//        let bottomColor2 = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9803921569, alpha: 1)
//
//        bottomView.addGradientLayer(colors: [bottomColor1, bottomColor2], locations: [0, 1], startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
    }
    
    func configure(with model: LibraryArticleDescriptionCellViewModel) {
        self.dateLabel.text = model.time
        self.descriptionLabel.text = model.text
        self.nameLabel.text = model.nameAuthor
        
        if let urlImage = URL(string: model.imgUrl) {
            imgView.kf.setImage(with: urlImage)
        }
        
        guard let url = URL(string: model.imgAvatarUrl) else { return }
        userImage.kf.setImage(with: url)
    }
    
}
