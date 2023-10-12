//
//  UIVIew+StaticFactoryMethods.swift
//  Extensions
//

import Foundation
import UIKit

public extension UIView {
    /// Can use in UIStackView to simulate a spacer view
    static var spacer: UIView {
        return UIView()
    }
}
