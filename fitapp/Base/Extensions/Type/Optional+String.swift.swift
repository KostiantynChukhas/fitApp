//
//  Optional+String.swift
//  Extensions
//
////

import Foundation

public extension Optional where Wrapped == String {
    /// If self is not optional returns self otherwise an empty string
    var orEmpty: String {
        return self ?? ""
    }
}
