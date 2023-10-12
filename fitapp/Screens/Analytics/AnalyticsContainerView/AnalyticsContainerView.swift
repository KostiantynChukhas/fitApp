//
//  AnalyticsContainerView.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import UIKit

class AnalyticsContainerView: FitView {
    
    private let containerView = UIView()
    
    private(set) var analyticsSegmentView = AnalyticsSegmentView()
    
    override func setupView() {
        backgroundColor = .clear
        analyticsSegmentView.backgroundColor = .clear
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(analyticsSegmentView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        analyticsSegmentView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview()
        }
    }
}
