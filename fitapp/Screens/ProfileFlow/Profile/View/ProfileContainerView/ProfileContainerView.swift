//
//  ProfileContainerView.swift
//  fitapp
//
//  Created by on 24.05.2023.
//

import UIKit

class ProfileContainerView: FitView {
    
    private let containerView = UIView()
    
    private(set) var topSegmentView = TopSegmentView()
    
    private(set) var mainSegmentView = MainSegmentView()
    
    override func setupView() {
        backgroundColor = .clear
        topSegmentView.backgroundColor = .clear
        mainSegmentView.backgroundColor = .clear
        
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(topSegmentView)
        containerView.addSubview(mainSegmentView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topSegmentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(62)
        }
        
        mainSegmentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(topSegmentView.snp.bottom)
        }
    }
    
}
