//
//  UIPageControl+Border.swift
//  Extensions
//

import UIKit

public extension UIPageControl {
    func style(dotFillColor: UIColor, dotBorderColor: UIColor, dotBorderWidth: CGFloat) {
        for (pageIndex, dotView) in subviews.enumerated() {
            if currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            } else {
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
}
