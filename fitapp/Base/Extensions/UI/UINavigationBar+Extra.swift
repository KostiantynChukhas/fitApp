//
//  UINavigationBar+Extra.swift
//  Extensions
//

import UIKit

// MARK: - Public

public extension UINavigationBar {
    func setShadowColor(color: UIColor) {
        shadowImage = color.as1ptImage()
    }
}

// MARK: - Private

private extension UINavigationBar {
    /// Find image (bottom separator line)
    private func findShadowImage() -> UIImageView? {
        return findShadowImage(under: self)
    }

    private func findShadowImage(under view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView,
            imageView.bounds.size.height <= 1
        {
            return imageView
        }

        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }
}

private extension UIColor {
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
