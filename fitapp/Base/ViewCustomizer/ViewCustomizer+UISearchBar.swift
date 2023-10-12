//
//  ViewCustomizer+UISearchBar.swift
//  ViewCustomizer
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UISearchBar {
    
    @discardableResult
    func set(barTintColor: UIColor?) -> Self {
        view?.barTintColor = barTintColor
        return self
    }

    @discardableResult
    func set(backgroundImage: UIImage?) -> Self {
        view?.backgroundImage = backgroundImage
        return self
    }

    @discardableResult
    func set(font: UIFont) -> Self {
        textField?.font = font
        return self
    }

    @discardableResult
    func set(textColor: UIColor?) -> Self {
        textField?.textColor = textColor
        return self
    }
    
    // MARK: - Private

    private var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return view?.searchTextField
        }

        guard
            let textView = view?.subviews.first?.subviews.compactMap({ $0 as? UITextField }).first
        else {
            assertionFailure("Could not find text field")
            return nil
        }

        return textView
    }
}
