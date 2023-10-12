//
//  Int+Casting.swift
//  Extensions//

import Foundation

public extension Int {
    /// Convert to Double type
    var double: Double { return Double(self) }

    /// Convert to CGFloat type
    var float: CGFloat { return CGFloat(self) }

    /// Convert to TimeInterval type
    var timeInterval: TimeInterval { return TimeInterval(self) }

    /// Convert to String type
    var stringValue: String { return String(self) }
}
