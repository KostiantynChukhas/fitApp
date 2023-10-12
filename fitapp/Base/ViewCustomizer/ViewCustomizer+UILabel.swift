//
//  ViewCustomizer+UILabel.swift
//  Extensions
//

import Foundation
import UIKit

// swiftlint:disable implicitly_unwrapped_optional
public extension ViewCustomizer where ViewType: UILabel {
    
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
    func set(numberOfLines: Int) -> Self {
        view?.numberOfLines = numberOfLines
        return self
    }

    @discardableResult
    func setMultiline() -> Self {
        view?.numberOfLines = 0
        return self
    }

    @discardableResult
    func set(textAlignment: NSTextAlignment) -> Self {
        view?.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func set(lineBreakMode: NSLineBreakMode) -> Self {
        view?.lineBreakMode = lineBreakMode
        return self
    }

    @discardableResult
    func set(minimumScaleFactor: CGFloat) -> Self {
        view?.adjustsFontSizeToFitWidth = true
        view?.minimumScaleFactor = minimumScaleFactor
        return self
    }
    
    @discardableResult
    func set(text: String) -> Self {
        view?.text = text
        return self
    }
}

// swiftlint:enable implicitly_unwrapped_optional
