//
//  UITextView+Extra.swift
//  Extensions
//

import UIKit

extension UITextView {
    
   public func textLengthValid(shouldChangeTextIn range: NSRange, replacementText: String, maxLength: Int) -> Bool {
       guard let string = self.text, let range = Range(range, in: string) else { return false }
        
        let substring = string[range]
        let count = string.count - substring.count + replacementText.count
        return count <= maxLength
    }
    
    public func textRangeFromNSRange(range: NSRange) -> UITextRange? {
        let beginning = beginningOfDocument
        guard let start = position(from: beginning, offset: range.location),
              let end = position(from: start, offset: range.length) else { return nil}
        return textRange(from: start, to: end)
    }
    
    public func configureAttributedLinks(text: String,
                                  urls: [String],
                                  linkColor: UIColor,
                                  attributes: [NSAttributedString.Key: Any]) {
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attributedText.length)
        
        for attribute in attributes {
            attributedText.addAttribute(attribute.key, value: attribute.value, range: range)
        }
        
        for url in urls {
            let linkRange = attributedText.mutableString.range(of: url)
            attributedText.addAttribute(.link, value: url, range: linkRange)
        }
        
        linkTextAttributes = [
            .foregroundColor: linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        self.attributedText = attributedText
    }
    
    public func resolveHashtags(with mentions: [String], urls: [String], hashtagFont: UIFont, regularFont: UIFont, linkColor: UIColor, foregroundColor: UIColor? = UIColor(hexString: "#050918"), mentionColor: UIColor? = UIColor(hexString: "#383892"), hashTagColor: UIColor? = UIColor(hexString: "#262626")) {
        let nsText = NSString(string: self.text)
        let words = nsText.components(separatedBy: " ")
        let attrString = NSMutableAttributedString(string: self.text)
        attrString.addAttributes([.foregroundColor: foregroundColor,
                                  .underlineStyle: 0,
                                  .font: regularFont],
                                 range: NSRange(location: 0, length: nsText.length))
        for word in words {
            if word.hasPrefix("#") {
                let matchRange:NSRange = nsText.range(of: word as String)
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                    return
                } else {
                    attrString.addAttributes([.foregroundColor: hashTagColor,
                                              .underlineStyle: 0,
                                              .font: hashtagFont],
                                             range: matchRange)
                }
                
            } else if word.hasPrefix("@"), mentions.contains(word) {
                let matchRange:NSRange = nsText.range(of: word as String)
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                    return
                } else {
                    attrString.addAttributes([.foregroundColor: mentionColor,
                                              .underlineStyle: 0,
                                              .font: hashtagFont],
                                             range: matchRange)
                    
                }
                
            }
        }
        let range = NSRange(location: 0, length: attrString.length)
                
        for url in urls {
            let linkRange = attrString.mutableString.range(of: url)
            attrString.addAttribute(.link, value: url, range: linkRange)
        }
        
        linkTextAttributes = [
            .foregroundColor: linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.attributedText = attrString
    }
    
    public func resolveHashTags(inText: String, hashtagFont: UIFont, regularFont: UIFont, foregroundColor: UIColor? = UIColor(hexString: "#050918"), mentionColor: UIColor? = UIColor(hexString: "#383892"), hashTagColor: UIColor? = UIColor(hexString: "#262626")) {
        
        let nsText = NSString(string: inText)
        let words = nsText.components(separatedBy: " ")
        let attrString = NSMutableAttributedString(string: inText)
        attrString.addAttributes([.foregroundColor: foregroundColor,
                                  .underlineStyle: 0,
                                  .font: regularFont],
                                 range: NSRange(location: 0, length: nsText.length))
        for word in words {
            if word.hasPrefix("#") {
                let matchRange:NSRange = nsText.range(of: word as String)
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                    return
                } else {
                    attrString.addAttributes([.foregroundColor: hashTagColor,
                                              .underlineStyle: 0,
                                              .font: hashtagFont],
                                             range: matchRange)
                }
                
            } else if word.hasPrefix("@") {
                let matchRange:NSRange = nsText.range(of: word as String)
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                    return
                } else {
                    attrString.addAttributes([.foregroundColor: mentionColor,
                                              .underlineStyle: 0,
                                              .font: hashtagFont],
                                             range: matchRange)
                    
                }
            }
        }
        self.attributedText = attrString
    }
    
    public func currentWord() -> String {
        guard let cursorRange = selectedTextRange else { return "" }
        func getRange(from position: UITextPosition, offset: Int) -> UITextRange? {
            guard let newPosition = self.position(from: position, offset: offset) else { return nil }
            return textRange(from: newPosition, to: position)
        }
        var wordStartPosition: UITextPosition = beginningOfDocument
        var wordEndPosition: UITextPosition = endOfDocument
        var position = cursorRange.start
        while let range = getRange(from: position, offset: -1), let text = text(in: range) {
            if text == " " || text == "\n" {
                wordStartPosition = range.end
                break
            }
            position = range.start
        }
        position = cursorRange.start
        while let range = getRange(from: position, offset: 1), let text = text(in: range) {
            if text == " " || text == "\n" {
                wordEndPosition = range.start
                break
            }
            position = range.end
        }
        guard let wordRange = textRange(from: wordStartPosition, to: wordEndPosition) else { return "" }
        return text(in: wordRange) ?? ""
    }
}

extension UITextView {

    public func numberOfLines() -> Int {
        if let lineHeight = font?.lineHeight, lineHeight != 0 {
            return Int(contentSize.height / lineHeight)
        }
        return 0
    }

}
