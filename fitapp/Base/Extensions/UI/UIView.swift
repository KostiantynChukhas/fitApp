//
//  UIView.swift
//  Extensions
//

import UIKit

public extension UIView {
    class var identifier: String {
        String(describing: self)
    }

    class var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
