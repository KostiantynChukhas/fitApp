//
//  UnitView.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

@IBDesignable
class UnitView: UIView {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var lbUnitsButton: RoundedButton!
    @IBOutlet weak var euUnitsButton: RoundedButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [lbUnitsButton, euUnitsButton].forEach {
            $0?.borderWidth = 1
            $0?.borderColor = .black
        }
    }
    
    func setTitle(_ value: String) {
        self.typeLabel.text = value
    }
    
    func setLeftButtonTitle(_ value: String) {
        self.euUnitsButton.setTitle(value, for: .normal)
        self.euUnitsButton.setTitleColor(.black)
    }
    
    func setRightButtonTitle(_ value: String) {
        self.lbUnitsButton.setTitle(value, for: .normal)
        self.lbUnitsButton.setTitleColor(.black)
    }

    func setSelected(with systemType: UnitSystemType) {
        switch systemType {
        case .eu:
            self.euUnitsButton.backgroundColor = Style.Color.starship.uiColor
            self.lbUnitsButton.backgroundColor = UIColor.white
        case .usa:
            self.euUnitsButton.backgroundColor = UIColor.white
            self.lbUnitsButton.backgroundColor = Style.Color.starship.uiColor
        }
    }
}
