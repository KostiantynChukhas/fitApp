//
//  HeaderCategory.swift
//  fitapp
//
//  on 12.05.2023.
//

import UIKit

class HeaderCategory: UIView {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        nibSetup()
        
        headerLabel.textColor = .black
        headerLabel.font = Style.Font.latoBold.uiFont.withSize(20)
        headerLabel.text = "Recommended"
    }
}
