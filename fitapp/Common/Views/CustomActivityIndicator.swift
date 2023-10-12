//
//  CustomActivityIndicator.swift
//  
//

import UIKit
import Lottie

class CustomActivityIndicator: UIView {
    let bgView = UIView()
    let animatedView = AnimationView(name: "loader")
    
    func setup(color: UIColor) {
        bgView.backgroundColor = color
        animatedView.animationSpeed = 2.0
        animatedView.loopMode = .loop
        bgView.isHidden = true
        self.isHidden = true
        
        self.addSubview(bgView)
        self.addSubview(animatedView)
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(frame.width)
            make.height.equalTo(frame.height)
        }
        animatedView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
    }
    
    func startAnimating() {
        bgView.isHidden = false
        animatedView.play()
        self.isHidden = false
    }
    
    func stopAnimating() {
        bgView.isHidden = true
        animatedView.stop()
        self.isHidden = true
    }
    
    func set(isLoading: Bool) {
        if isLoading {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
