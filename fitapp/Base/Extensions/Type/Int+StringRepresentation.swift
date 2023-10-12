//
//  Int+StringRepresentation.swift
//  Extensions
//

import Foundation

public extension Int {
    /// Represantation such as "2,234,232"
    var decimalStringRepresentation: String {
        NumberFormatter.number.string(from: NSNumber(value: self)) ?? ""
    }
}

private extension NumberFormatter {
    static var number: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}
