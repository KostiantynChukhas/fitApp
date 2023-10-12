//
//  TabBarItemView.swift
//  fitapp
//
//  Created by on 12.05.2023.
//

import UIKit

protocol TabBarItemViewDelegate: AnyObject {
    func didClicked(item: TabBarItemView)
}

@IBDesignable
class TabBarItemView: UIView {
    
    weak var delegate: TabBarItemViewDelegate?
    
    @IBInspectable var title: String = "" {
        didSet {
            self.expandedButton.setTitle(title, for: .normal)
        }
    }
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            self.collapsedButton.setImage(image, for: .normal)
            self.expandedButton.setImage(image?.withTintColor(.black), for: .normal)
        }
    }
    
    @IBInspectable
    var isSelected: Bool = false {
        didSet {
            self.collapsedButton.isHidden = isSelected
            self.expandedButton.isHidden = !isSelected
            
            self.collapsedButton.alpha = isSelected ? 0: 1
            self.expandedButton.alpha = isSelected ? 1: 0
        }
    }
    
    @IBOutlet weak var collapsedButton: UIButton!
    @IBOutlet weak var expandedButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        expandedButton.setInsets(
            forContentPadding: .init(vertical: 5, horizontal: 10),
            imageTitlePadding: 5
        )
        
        expandedButton.layer.cornerRadius = expandedButton.frame.height / 2
    }
    
    private func setupView() {
        
    }
    
    @IBAction func tabButtonAction(_ sender: Any) {
        delegate?.didClicked(item: self)
    }
    
    func select(_ value: Bool, animated: Bool = false) {
        self.isSelected = value
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .showHideTransitionViews) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
 }
