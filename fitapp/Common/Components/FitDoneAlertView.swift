//
//  FitDoneAlert.swift
//  fitapp
//

import UIKit

final class FitDoneAlertView: UIView {
    
    @IBOutlet weak var lbMsg: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.nibSetup()
        self.bgView.roundCorners(radius: 12)
    }
    
    private var actionHandler: (()-> Void)?
    
    func configure(actionHandler: (() -> Void)?) {
        self.actionHandler = actionHandler
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        actionHandler?()
        removeFromSuperview()
    }
}


