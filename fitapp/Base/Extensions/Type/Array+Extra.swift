//
//  Array+Extra.swift
//  Extensions//

import Foundation

public extension Array {
    var middle: Element? {
        guard !isEmpty else { return nil }

        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }

    func nilIfEmpty() -> Self? {
        return isEmpty ? nil : self
    }

    mutating func replaceElements(to newElement: Element, when condition: (Element) -> Bool) {
        self = map { element in
            condition(element) ? newElement : element
        }
    }
}

public extension Array where Element: Comparable {
    func equals(other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
