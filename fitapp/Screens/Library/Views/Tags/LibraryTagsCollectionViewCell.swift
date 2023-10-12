//
//  LibraryTagsCollectionViewCell.swift
//  fitapp
//
//  on 08.05.2023.
//

import UIKit

class LibraryTagsCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var tagsButton: RoundedButton!
    
    private var model: TagCategoryModel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configure(with: self.model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tagsButton.configure(style: .dark)
        tagsButton.cornerRadius = 13
    }
    
    func configure(with model: TagCategoryModel) {
        self.model = model
        tagsButton.setTitle(model.title, for: .normal)
    }

}
