//
//  FitAppAlertView.swift
//  fitapp
//

import UIKit

final class FitAppAlertView: UIView {
    
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
    
    func configure(title: String? = nil, msg: String? = nil, btn: String = "OK", actionHandler: (() -> Void)?) {
        lbTitle.text = title
        lbMsg.text = msg
        continueButton.setTitle(btn, for: .normal)
        self.actionHandler = actionHandler
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        actionHandler?()
        removeFromSuperview()
    }
}


