//
//  Reusable.swift
//  Extensions
//

import UIKit

public protocol Reusable {
    static var reuseID: String { get }
}

public extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}
