//
//  RateStarsView.swift
//  
//
//  Created by  on 05.03.2023.
//  Copyright © 2023 Nikola Milic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objc
enum StarColor: Int {
    case gold = 0
    case red
    case green
}

protocol RateStatsViewDelegate: AnyObject {
    func didSelect(value: Int)
}

@IBDesignable
class RateStarsView: FitView {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let starsButton = [UIButton(), UIButton(), UIButton(), UIButton(), UIButton()]
    
    @IBInspectable var spacing: CGFloat = 0 {
        didSet { stackView.spacing = spacing }
    }
    
    @IBInspectable var color: StarColor = .gold {
        didSet {
            switch color {
            case .gold: selectedStarImage = UIImage(named: "star_selected")
            case .green: selectedStarImage = UIImage(named: "star_selected_green")
            case .red: selectedStarImage = UIImage(named: "star_selected_red")
            }
            
            selectForIndex(index: stars - 1)
        }
    }
    
    private var selectedStarImage = UIImage(named: "star_selected") {
        didSet { setupView() }
    }
    
    @IBInspectable var stars: Int = 1 {
        didSet { self.selectForIndex(index: stars - 1) }
    }
    
    @IBInspectable var isEditable: Bool = true {
        didSet { stackView.isUserInteractionEnabled = isEditable }
    }
    
    weak var delegate: RateStatsViewDelegate?
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        stackView.backgroundColor = .clear
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        for index in 0..<starsButton.count {
            starsButton[index].setImage(UIImage(named: "star_not_selected"), for: .normal)
            starsButton[index].addTarget(self, action: #selector(starSelected), for: .touchUpInside)
        }
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        for button in starsButton {
            stackView.addArrangedSubview(button)
            
            button.snp.makeConstraints {
                $0.height.equalTo(button.snp.width)
            }
        }
    }
    
    @objc func starSelected(_ sender: UIButton) {
        guard let index = starsButton.firstIndex(of: sender) else { return }
        
        self.selectForIndex(index: index)
        self.delegate?.didSelect(value: index + 1)
    }
 
    private func selectForIndex(index: Int) {
        for index in 0...index {
            starsButton[index].setImage(selectedStarImage, for: .normal)
        }
        
        for leftIndeces in (index + 1)..<starsButton.count {
            starsButton[leftIndeces].setImage(UIImage(named: "star_not_selected"), for: .normal)
        }
    }
}
