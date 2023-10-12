//
//  RequestDynamicDataModel.swift
//  Networking
//

import Foundation

public struct RequestDynamicDataModel: RequestModelTypeProtocol {
    // MARK: - Properties

    public var authorizationToken: String?
    
    public var uuid: String?
    
    public var parameters: [String: Any]? {
        return sendData.convertToDictionary()
    }

    public let sampleData: Data?

    public let baseUrl: URL

    public let pathEnding: String?

    // MARK: - Private Properties

    public let sendData: Data

    // MARK: - Constructor

    public init(
        sendData: Data,
        baseUrl: URL,
        authorizationToken: String? = nil,
        uuid: String?,
        mockData: Data? = nil,
        pathEnding: String? = nil
    ) {
        self.sendData = sendData
        self.authorizationToken = authorizationToken
        self.uuid = uuid
        self.sampleData = mockData
        self.baseUrl = baseUrl
        self.pathEnding = pathEnding
    }
    
    ///Empty init
    public init() {
        self.sendData = Data()
        self.authorizationToken = nil
        self.sampleData = nil
        self.baseUrl = URL.init(fileURLWithPath: "")
        self.pathEnding = nil
        self.uuid = nil
    }
}
