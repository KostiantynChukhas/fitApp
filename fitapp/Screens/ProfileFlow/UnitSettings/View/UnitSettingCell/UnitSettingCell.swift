//
//  UnitSettingCell.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

class UnitSettingCell: UITableViewCell, Reusable {

    @IBOutlet weak var unitView: UnitView!
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(with model: UnitSettingCellViewModel) {
        unitView.setTitle(model.unitType.title)
        unitView.setLeftButtonTitle(model.unitType.getLeftTitle())
        unitView.setRightButtonTitle(model.unitType.getRightTitle())
        unitView.setSelected(with: model.selectedSystemType)
        
        unitView.isUserInteractionEnabled = model.isEditable
        
        Observable.merge(
            unitView.euUnitsButton.rx.tap.map { UnitSystemType.eu },
            unitView.lbUnitsButton.rx.tap.map { UnitSystemType.usa }
        )
        .bind(to: model.didSelectType)
        .disposed(by: disposeBag)
        
        model.didSelectType.subscribe(onNext: { [weak self] in
            self?.unitView.setSelected(with: $0)
        }).disposed(by: disposeBag)
    }
}
