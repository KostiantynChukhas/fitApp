//
//  DiscoverTagsCollectionViewCell.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 03.07.2023.
//

import UIKit

class DiscoverTagsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagsButton: RoundedButton!
    
//    private var model: LibraryCategoryModel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.configure(with: self.model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tagsButton.configure(style: .dark)
        tagsButton.cornerRadius = 13
    }
    
//    func configure(with model: LibraryCategoryModel) {
//        self.model = model
//        tagsButton.setTitle(model.title, for: .normal)
//    }

}
