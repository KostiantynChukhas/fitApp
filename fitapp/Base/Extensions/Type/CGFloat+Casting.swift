//
//  CGFloat+Casting.swift
//  Extensions//

import UIKit

public extension CGFloat {
    /// Convert to Float type
    var float: Float { return Float(self) }

    /// Convert to Double type
    var double: Double { return Double(self) }

    /// Convert to Int type
    var int: Int { return Int(self) }

    /// Convert to timeInterval type
    var timeInterval: TimeInterval { return TimeInterval(self) }
}
