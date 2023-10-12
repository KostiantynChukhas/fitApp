//
//  ResponseBaseModelsProtocol.swift
//  Networking
//

import Foundation

public protocol ResponseBaseModelsProtocol {
    var message: String? { get }
//    var code: Int? { get }
    var error: String? { get }
    var count: Int? { get }
    var serverStatusCode: Int? { get }
}
