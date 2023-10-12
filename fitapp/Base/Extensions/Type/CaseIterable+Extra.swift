//
//  CaseIterable+Extra.swift
//  Extensions//
//

import Foundation

public extension CaseIterable where Self: Equatable {
    /// Take the next element of the case.
    /// If the element is the last in the array allCases, then the first element is taken
    func next() -> Self {
        let allCases = Self.allCases
        guard let currentIndex = allCases.firstIndex(of: self) else {
            return self
        }
        let nextIndex = Self.allCases.index(after: currentIndex)
        return allCases[nextIndex == allCases.endIndex ? allCases.startIndex : nextIndex]
    }
}
