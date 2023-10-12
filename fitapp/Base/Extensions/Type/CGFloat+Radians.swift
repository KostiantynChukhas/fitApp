//
//  CGFloat+Radians.swift
//  Extensions
//
////

import Foundation

public extension CGFloat {
    /// Convert degrees pass value to radians value
    static func radians(fromDegrees: CGFloat) -> CGFloat {
        return CGFloat(fromDegrees * .pi / 180)
    }

    /// Convert radians value to degrees value
    static func degrees(fromRadians: CGFloat) -> CGFloat {
        return CGFloat(fromRadians * 180 / .pi)
    }
}
