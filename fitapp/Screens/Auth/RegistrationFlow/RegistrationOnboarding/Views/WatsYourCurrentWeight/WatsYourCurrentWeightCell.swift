//
//  WatsYourCurrentWeightCell.swift
//  fitapp
//
// on 05.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

class WatsYourCurrentWeightCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var metricLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    private var disposeBag = DisposeBag()
    private var model: WatsYourCurrentWeightCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let model = model {
            self.configure(with: model)
        }
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [leftButton, rightButton] .forEach {
            $0.roundCorners(radius: 15)
            $0.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
        }
        
        leftButton.isSelected = true
        updateUI()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func configure(with model: WatsYourCurrentWeightCellViewModel) {
        self.model = model
        let leftSignal = leftButton.rx.tap.map { TypeMetricSystem.Eu }
        let rightSignal = rightButton.rx.tap.map { TypeMetricSystem.Usa }
        
        if model.typeCells == .currentWeight {
            Observable.merge(leftSignal, rightSignal)
                .bind(to: model.typeObservable)
                .disposed(by: disposeBag)
        }
        
        switch model.typeCells {
        case .currentWeight:
            titleLabel.text = "What’s your current weight?"
            leftButton.setTitle("kg", for: .normal)
            rightButton.setTitle("lb", for: .normal)
            metricLabel.text = model.type == .Eu ? "kg": "lb"
            leftButton.isUserInteractionEnabled = true
            rightButton.isUserInteractionEnabled = true
            textField.text = model.weight == 0 ? "" : "\(model.weight)"
        case .goalWeight:
            titleLabel.text = "What’s your goal weight?"
            leftButton.setTitle("kg", for: .normal)
            rightButton.setTitle("lb", for: .normal)
            leftButton.isUserInteractionEnabled = false
            rightButton.isUserInteractionEnabled = false
            metricLabel.text = model.type == .Eu ? "kg": "lb"
            textField.text = model.goalWeight == 0 ? "" : "\(model.goalWeight)"
        case .currentHeight:
            titleLabel.text = "What’s your height?"
            leftButton.setTitle("cm", for: .normal)
            rightButton.setTitle("inch", for: .normal)
            metricLabel.text = model.type == .Eu ? "cm": "inch"
            leftButton.isUserInteractionEnabled = false
            rightButton.isUserInteractionEnabled = false
            textField.text = model.height == 0 ? "" : "\(model.height)"
        }
        
        updateUI()
    }
    
    func updateUI() {
        leftButton.isSelected = model?.type == .Eu
        rightButton.isSelected = model?.type == .Usa
        
        leftButton.setBackgroundColor(color: getColors(isSelected: leftButton.isSelected) , forState: .normal)
        rightButton.setBackgroundColor(color: getColors(isSelected: rightButton.isSelected), forState: .normal)
        
        if let model = model {
            switch model.typeCells {
            case .currentHeight: metricLabel.text = model.type == .Eu ? "cm": "inch"
            default: metricLabel.text = model.type == .Eu ? "kg": "lb"
            }
        }
        
        leftButton.alpha = model?.type == .Eu ? 1: 0.5
        rightButton.alpha = model?.type != .Eu ? 1: 0.5
    }
    
    private func getColors(isSelected: Bool) -> UIColor {
        return isSelected ? Style.Color.starship.uiColor : .white
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let value = textField.text else { return }
        guard let model = model else { return }
        switch model.typeCells {
        case .goalWeight: model.goalWeight = Int(value) ?? .zero
        case .currentWeight: model.weight = Int(value) ?? .zero
        case .currentHeight: model.height = Int(value) ?? .zero
        }
    }

    @IBAction func rightButtonAction(_ sender: Any) {
        guard model?.typeCells == .currentWeight else { return }
        model?.type = .Usa
        updateUI()
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        model?.type = .Eu
        updateUI()
    }
}
