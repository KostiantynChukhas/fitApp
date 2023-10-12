//
//  UIView+addGradientLayer.swift
//  fitapp
//
//  on 14.05.2023.
//

import Foundation
import UIKit

extension UIView {
    func addGradientLayer(colors: [UIColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
