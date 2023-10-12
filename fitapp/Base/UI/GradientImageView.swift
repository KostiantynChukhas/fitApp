//
//  GradientImageView.swift
//  fitapp
//
// on 04.05.2023.
//

import UIKit

class GradientImageView: UIImageView {
    
    var startColor: UIColor = .clear
    var endColor: UIColor = .black

    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }

    private func addGradient() {
        // create the gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // set the gradient layer frame to cover only the bottom 40 points of the view
        let gradientHeight: CGFloat = 40.0
        gradientLayer.frame = CGRect(x: 0, y: bounds.height - gradientHeight, width: bounds.width, height: gradientHeight)
        
        // add the gradient layer to the view's layer
        layer.addSublayer(gradientLayer)
    }

}
