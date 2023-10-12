//
//  UILabel+WidthResize.swift
//  Extensions
//

import Foundation
import UIKit

public extension UILabel {
    /// Use this method for set min font size if all text does not fit in width.
    /// But only after set original font
    func setMinFontSize(_ minFontSize: CGFloat) {
        let currentSize = font.pointSize
        adjustsFontSizeToFitWidth = true
        let factor = minFontSize / currentSize
        minimumScaleFactor = factor
    }
}
