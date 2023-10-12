//
//  UnknownCodingKey.swift
//

import Foundation

struct UnknownCodingKey: CodingKey {
    let stringValue: String

    var intValue: Int? {
        return nil
    }

    // MARK: - Constructor

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}
