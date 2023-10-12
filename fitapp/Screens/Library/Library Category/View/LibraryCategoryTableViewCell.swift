//
//  LibraryCategoryTableViewCell.swift
//  fitapp
//
//  on 11.05.2023.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class LibraryCategoryTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    private var model: TagCategoryModel!
    
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.roundCorners(radius: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func configure(with model: TagCategoryModel) {
        titleLabel.text = model.title
        imgView.image = UIImage(named: model.image)
                model.selectedRelay.asObservable().subscribe { [weak self] value in
            self?.checkmarkButton.isSelected = value
        }
        .disposed(by: disposeBag)
        
        self.checkmarkButton.isSelected = model.isSelected

        
//        guard let url = URL(string: model.image) else { return }
//        imgView.kf.setImage(with: url)
    }
}


class TagCategoryModel: Equatable, Codable {
    static func == (lhs: TagCategoryModel, rhs: TagCategoryModel) -> Bool {
        return lhs.title == rhs.title && lhs.id == rhs.id
    }

    let title: String
    let image: String
    var isSelected: Bool
    let id: Int
    
    init(title: String, image: String, isSelected: Bool, id: Int) {
        self.title = title
        self.image = image
        self.isSelected = isSelected
        self.id = id
    }
    
    lazy var selectedRelay = BehaviorRelay<Bool>(value: isSelected)
    
    func toggle() {
        self.isSelected = !self.isSelected
        let value = selectedRelay.value
        selectedRelay.accept(!value)
    }
    
    func select(_ value: Bool) {
        self.isSelected = value
        selectedRelay.accept(value)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, image, isSelected, id
    }
}
