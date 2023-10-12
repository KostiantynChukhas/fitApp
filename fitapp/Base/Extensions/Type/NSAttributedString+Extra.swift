//
//  NSAttributedString+Extra.swift
//  Extensions//

import UIKit

public extension NSAttributedString {
    /// Calculate the value of the height of the text at a given width
    func height(withWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(
            width: width,
            height: CGFloat.greatestFiniteMagnitude
        )
        let actualSize = boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin],
            context: nil
        )
        return actualSize.height
    }

    func width(withHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(
            width: .greatestFiniteMagnitude,
            height: height
        )
        let boundingBox = boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )

        return ceil(boundingBox.width)
    }
}

public extension NSAttributedString {
    func rangesOf(subString: String) -> [NSRange] {
        var nsRanges: [NSRange] = []
        let ranges = string.getRanges(of: subString, options: .caseInsensitive)
        
        for range in ranges {
            nsRanges.append(range.nsRange)
        }
        
        return nsRanges
    }
}

public extension NSTextAttachment {
    func setImageHeight(_ height: CGFloat, verticalOffset: CGFloat = .zero) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height

        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - verticalOffset, width: ratio * height, height: height)
    }
}
