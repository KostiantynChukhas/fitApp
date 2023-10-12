//
//  RequestModelTypeProtocol.swift
//  Networking
//

import Foundation

public protocol RequestModelTypeProtocol {
    var baseUrl: URL { get }

    var authorizationToken: String? { get }

    var parameters: [String: Any]? { get }

    var sampleData: Data? { get }

    var pathEnding: String? { get }

    var uuid: String? { get }
    
    var customeHeaderParameters: [String: String?]? { get }
}

// MARK: - RequestTypeObject extension

public extension RequestModelTypeProtocol {
    var authorizationToken: String? {
        return nil
    }

    var parameters: [String: Any]? {
        return nil
    }

    var sampleData: Data? {
        return nil
    }

    var pathEnding: Data? {
        return nil
    }

    var customeHeaderParameters: [String: String?]? {
        return nil
    }
}
