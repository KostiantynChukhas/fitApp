//
//  LibraryTableViewCell.swift
//  fitapp
//
//  on 10.05.2023.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class LibraryTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    private var model: LibraryList!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.roundCorners(radius: 20)
    }
    
    func configure(with model: LibraryList, disposeBag: DisposeBag) {
        self.model = model
        
        readMoreButton.rx.tap
            .bind(to: model.rx.selectTapEvent)
            .disposed(by: disposeBag)
        
        titleLabel.text = model.title
        imgView.image = UIImage(named: model.img)
        
        guard let url = URL(string: model.img) else { return }
        imgView?.kf.setImage(with: url)
    }
}

class LibraryList: ReactiveCompatible {
    let title: String
    let img: String
    let id: String
    
    fileprivate var selectTapPublisher = PublishSubject<String>()
    
    init(title: String, img: String, id: String) {
        self.title = title
        self.img = img
        self.id = id
    }
    
    func selectTapObservable() -> Observable<String> {
        return selectTapPublisher.asObservable()
    }
}

extension Reactive where Base: LibraryList {
    var selectTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.selectTapPublisher.onNext(String(base.id))
        }
    }
}
