//
//  DataArrayModel.swift
//  Core
//

import Foundation

public struct DataArrayModel<T>: Equatable where T: Decodable, T: Equatable {
    // MARK: - Properties

    public let data: T
    public let count: Int?

    // MARK: - Constructor

    public init(data: T, count: Int?) {
        self.data = data
        self.count = count
    }
}
