//
//  ViewCustomizer+UIView.swift
//  ViewCustomizer
//

import Foundation
import UIKit

// swiftlint:disable implicitly_unwrapped_optional

public extension ViewCustomizer where ViewType: UIView {
    
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func setClearBackground() -> Self {
        return set(backgroundColor: .clear)
    }

    @discardableResult
    func set(clipsToBounds: Bool) -> Self {
        view?.clipsToBounds = clipsToBounds
        return self
    }

    @discardableResult
    func set(contentMode: UIView.ContentMode) -> Self {
        view?.contentMode = contentMode
        return self
    }

    @discardableResult
    func set(tintColor: UIColor!) -> Self {
        view?.tintColor = tintColor
        return self
    }

    @discardableResult
    func set(isHidden: Bool) -> Self {
        view?.isHidden = isHidden
        return self
    }

    @discardableResult
    func set(isUserInteractionEnabled: Bool) -> Self {
        view?.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    // MARK: - Layers

    @discardableResult
    func set(masksToBounds: Bool) -> Self {
        view?.layer.masksToBounds = masksToBounds
        return self
    }

    @discardableResult
    func set(cornerRadius: CGFloat) -> Self {
        view?.layer.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    func set(maskedCorners: CACornerMask) -> Self {
        view?.layer.maskedCorners = maskedCorners
        return self
    }
    
    @discardableResult
    func set(borderWidth: CGFloat, borderColor: UIColor?) -> Self {
        return set(borderWidth: borderWidth)
            .set(borderColor: borderColor)
    }
    
    @discardableResult
    func set(borderWidth: CGFloat) -> Self {
        view?.layer.borderWidth = borderWidth
        return self
    }
    @discardableResult
    func set(borderColor: UIColor?) -> Self {
        view?.layer.borderColor = borderColor?.cgColor
        return self
    }

    @discardableResult
    func set(alpha: CGFloat) -> Self {
        view?.alpha = alpha
        return self
    }

    @discardableResult
    func set(tag: Int) -> Self {
        view?.tag = tag
        return self
    }
}

// swiftlint:enable implicitly_unwrapped_optional
