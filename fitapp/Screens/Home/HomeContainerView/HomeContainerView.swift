//
//  HomeContainerView.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit

class HomeContainerView: FitView {
    
    private let containerView = UIView()
    
    private(set) var homeSegmentView = HomeSegmentView()
    
    override func setupView() {
        backgroundColor = .clear
        homeSegmentView.backgroundColor = .clear
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(homeSegmentView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        homeSegmentView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview()
        }
    }    
}
