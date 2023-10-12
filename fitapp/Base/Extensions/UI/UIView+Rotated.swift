//
//  UIView+Rotated.swift
//  Extensions
//

import UIKit

public extension UIView {
    func rotate() {
        if transform == CGAffineTransform.identity {
            transform = CGAffineTransform.identity.rotated(by: .pi)
        }
    }
}
