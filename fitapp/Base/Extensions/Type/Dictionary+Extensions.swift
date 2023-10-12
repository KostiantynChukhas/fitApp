//
//  Dictionary+Extensions.swift
//  Extensions//

import Foundation

public extension Dictionary where Key == String, Value == Any {

    var trimmingEmptyValues: [String: Any] {
        var copy = self
        forEach { (key, value) in
            if let string = value as? String, string.isEmpty {
                copy.removeValue(forKey: key)
            } else if value == nil {
                copy.removeValue(forKey: key)
            }
        }
        return copy
    }
}
