//
//  UISearchBar+Extra.swift
//  Extensions
//

import UIKit

public extension UISearchBar {
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        }

        guard let firstSubview = subviews.first else {
            assertionFailure("Could not find text field")
            return nil
        }

        for view in firstSubview.subviews {
            if let textView = view as? UITextField {
                return textView
            }
        }

        assertionFailure("Could not find text field")

        return nil
    }

    func setMagnifyingGlassColorTo(color: UIColor) {
        let glassIconView = textField?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
}
