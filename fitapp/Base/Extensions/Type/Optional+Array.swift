//
//  Optional+Array.swift
//  Extensions//
//

import Foundation

public extension Optional {
    func orEmptyArray<T>() -> [T] where Wrapped == [T] {
        return self ?? []
    }
}
