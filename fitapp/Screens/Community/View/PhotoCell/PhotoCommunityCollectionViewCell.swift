//
//  PhotoCommunityCollectionViewCell.swift
//  fitapp
//
//  on 21.05.2023.
//

import UIKit

class PhotoCommunityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }

}
