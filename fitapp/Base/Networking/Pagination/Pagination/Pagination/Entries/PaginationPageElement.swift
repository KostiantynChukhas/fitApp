//
//  PaginationPageElement.swift
//  Pagination
//

import Foundation

public struct PaginationPageElement<Dependency, Element> {
    let nextDependency: Dependency?
    let elements: [Element]

    public init(nextDependency: Dependency?, elements: [Element]) {
        self.nextDependency = nextDependency
        self.elements = elements
    }
}
