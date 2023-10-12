//
// String+NSAttributedString.swift
// Pods//

import UIKit

public extension String {
    func attributed(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}

public extension NSTextAttachment {
    static func getCenteredImageAttachment(with imageName: String, font: UIFont?) -> NSTextAttachment {
        let imageAttachment = NSTextAttachment()
        guard let image = UIImage(named: imageName),
            let font = font else { return imageAttachment }

        imageAttachment.bounds = CGRect(
            x: 0,
            y: (font.capHeight - image.size.height).rounded() / 2,
            width: image.size.width,
            height: image.size.height
        )
        imageAttachment.image = image
        return imageAttachment
    }
}
