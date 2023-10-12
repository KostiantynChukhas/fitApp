//
//  ViewCustomizer+UITextField.swift
//  ViewCustomizer
//

import Foundation
import UIKit

// swiftlint:disable implicitly_unwrapped_optional

public extension ViewCustomizer where ViewType: UITextField {
    
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
    func set(placeHolderColor color: UIColor!) -> Self {
        let placeholder = view?.placeholder ?? ""
        let attributes = [NSAttributedString.Key.foregroundColor : color]
        view?.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: attributes)
        return self
    }
    
    @discardableResult
    func set(keyboardType: UIKeyboardType) -> Self {
        view?.keyboardType = keyboardType 
        return self
    }
    
    @discardableResult
    func set(borderStyle: UITextField.BorderStyle) -> Self {
        view?.borderStyle = borderStyle
        return self
    }
    
    @discardableResult
    func set(alignment: NSTextAlignment) -> Self {
        view?.textAlignment = alignment
        return self
    }
    @discardableResult
    func set(attributedPlaceholder: NSAttributedString) -> Self {
        view?.attributedPlaceholder = attributedPlaceholder
        return self
    }
}

// swiftlint:enable implicitly_unwrapped_optional
