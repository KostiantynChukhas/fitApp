//
//  ViewCustomizer+UITextView.swift
//  Extensions
//

import Foundation
import UIKit

// swiftlint:disable implicitly_unwrapped_optional
public extension ViewCustomizer where ViewType: UITextView {
    
    @discardableResult
    func set(font: UIFont) -> Self {
        view?.font = font
        return self
    }

    @discardableResult
    func set(textColor: UIColor!) -> Self {
        view?.textColor = textColor
        return self
    }
    
    @discardableResult
    func set(textAlignment: NSTextAlignment) -> Self {
        view?.textAlignment = textAlignment
        return self
    }
}

// swiftlint:enable implicitly_unwrapped_optional
