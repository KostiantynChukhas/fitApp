//
//  PageState.swift
//  Pagination
//

import Foundation

public struct PageState<Element> {
    public let isLoading: Bool
    public let error: Error?
    public let elements: [Element]
}
