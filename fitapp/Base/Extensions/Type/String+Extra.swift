//
//  String+Extra.swift
//  Extensions
//

import UIKit

public extension String {
    /// Calculate the value of the height of the text at a given width and font
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(
            width: width,
            height: CGFloat.greatestFiniteMagnitude
        )
        let actualSize = (self as NSString).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin],
            attributes: [.font: font],
            context: nil
        )
        return actualSize.height
    }

    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = (self as NSString).boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return ceil(boundingBox.width)
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func widthOfString(forAttributes attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let size = self.size(withAttributes: attributes)
        return size.width
    }
    
    func contains(anyOf strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }

    /// Return nil if current string is empty
    func nilIfEmpty() -> String? {
        return isEmpty ? nil : self
    }

    func removingLinesAndSpaces() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static let empty = ""
    
    func replacingSpaceWithUnderScore() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
    
    func findHashtagsInText() -> [String] {
        var arr_hasStrings:[String] = []
        let regex = try? NSRegularExpression(pattern: "(#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: self, options: [], range: NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location: match.range.location, length: match.range.length )))
            }
        }
        return arr_hasStrings
    }
}

public extension String {
    func cleanExtraSpacesInside() -> String {
        let spaceChar = " "
        let newLineChar = "\n"
        let allowedCharCount = 2
        
        let trimmed = removeAlteratingChars(spaceChar, newLineChar)
        let withoutSpaces = trimmed.removeRepeatsToAllowedCount(char: spaceChar, maxAllowedCount: allowedCharCount)
        let withoutNewLines = withoutSpaces.removeRepeatsToAllowedCount(char: newLineChar, maxAllowedCount: allowedCharCount)
        
        return withoutNewLines
    }
    
    fileprivate func removeAlteratingChars(_ firstChar: String, _ secondChar: String) -> String {
        let alteratingSpaceAndLine = firstChar + secondChar
        let alteratingLineAndSpace = secondChar + firstChar
        let resultChar = secondChar
        let removedAlteratingSpacesAndLine = replaceRepeats(of: alteratingSpaceAndLine, with: resultChar)
        let removedAlteratingLineAndSpaces = replaceRepeats(of: alteratingLineAndSpace, with: resultChar)
        
        return removedAlteratingLineAndSpaces.removingLinesAndSpaces()
    }
    
    fileprivate func removeRepeatsToAllowedCount(char: String, maxAllowedCount: Int) -> String {
        let allowedCharSequence = String(repeating: char, count: maxAllowedCount)
        let notAllowedCharSequence = String(repeating: char, count: maxAllowedCount + 1)
        
        return replaceRepeats(of: notAllowedCharSequence, with: allowedCharSequence)
    }
    
    fileprivate func replaceRepeats(of initialChars: String, with resultChars: String) -> String {
        var currentString = self
        while currentString.contains(initialChars) {
            currentString = currentString.replacingOccurrences(of: initialChars, with: resultChars)
        }
        return currentString
    }
}

public extension String {
    func getRanges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex) ..< self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
}

public extension String {
    func removeLines() -> String {
        return replacingOccurrences(of: "\n", with: " ")
    }
    
}
