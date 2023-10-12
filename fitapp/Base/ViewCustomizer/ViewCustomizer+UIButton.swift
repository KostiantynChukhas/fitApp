//
//  ViewCustomizer+UIButton.swift
//  Extensions
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIButton {
    
    @discardableResult
    func set(normalTitleColor: UIColor?) -> Self {
        view?.setTitleColor(normalTitleColor, for: .normal)
        return self
    }
    
    @discardableResult
    func set(font: UIFont) -> Self {
        view?.titleLabel?.font = font
        return self
    }

    @discardableResult
    func set(image: UIImage?) -> Self {
        view?.setImage(image, for: .normal)
        return self
    }
    
    @discardableResult
    func setSelected(image: UIImage?) -> Self {
        view?.setImage(image, for: .selected)
        return self
    }

    @discardableResult
    func set(imageContentMode: UIView.ContentMode) -> Self {
        view?.imageView?.contentMode = imageContentMode
        return self
    }
    
    @discardableResult
    func set(textAlignment: NSTextAlignment) -> Self {
        view?.titleLabel?.textAlignment = textAlignment
        return self
    }
    
    
    @discardableResult
    func set(titleContentMode: UIView.ContentMode) -> Self {
        view?.titleLabel?.contentMode = titleContentMode
        return self
    }

    @discardableResult
    func set(imageEdgeInsets: UIEdgeInsets) -> Self {
        view?.imageEdgeInsets = imageEdgeInsets
        return self
    }

    @discardableResult
    func set(imageEdgeInsets: CGFloat) -> Self {
        view?.imageEdgeInsets = .init(
            top: imageEdgeInsets,
            left: imageEdgeInsets,
            bottom: imageEdgeInsets,
            right: imageEdgeInsets
        )
        return self
    }
    
    @discardableResult
    func set(titleEdgeInsets: UIEdgeInsets) -> Self {
        view?.titleEdgeInsets = titleEdgeInsets
        return self
    }
    
    @discardableResult
    func set(contentEdgeInsets: UIEdgeInsets) -> Self {
        view?.contentEdgeInsets = contentEdgeInsets
        return self
    }
    
    @discardableResult
    func set(isEnabled: Bool) -> Self {
        view?.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func set(title: String?, for state: UIControl.State = .normal) -> Self {
        view?.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func set(attributedTitle: NSAttributedString) -> Self {
        view?.setAttributedTitle(attributedTitle, for: .normal)
        return self
    }
    
    @discardableResult
    func set(numberOfLines: Int) -> Self {
        view?.titleLabel?.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult
    func set(lineBreakMode: NSLineBreakMode) -> Self {
        view?.titleLabel?.lineBreakMode = lineBreakMode
        return self
    }
}
