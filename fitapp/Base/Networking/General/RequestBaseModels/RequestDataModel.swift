//
//  RequestDataModel.swift
//  Networking
//

import Foundation

public struct EmptyRequestData: Encodable {
    public init() {}
}

public struct RequestDataModel<SendData: Encodable>: RequestModelTypeProtocol {
    // MARK: - Properties

    public var authorizationToken: String?
    
    public var uuid: String?

    public var parameters: [String: Any]? {
        return sendData.asDictionary()
    }

    public var sampleData: Data? {
        return sendData.convertToData()
    }

    public let baseUrl: URL

    public let pathEnding: String?

    public let customeHeaderParameters: [String: String?]?

    // MARK: - Private Properties

    private let sendData: SendData

    // MARK: - Constructor

    public init(
        sendData: SendData,
        baseUrl: URL,
        authorizationToken: String? = nil,
        uuid: String?,
        pathEnding: String? = nil,
        customeHeaderParameters: [String: String?]? = nil
    ) {
        self.sendData = sendData
        self.authorizationToken = authorizationToken
        self.uuid = uuid
        self.baseUrl = baseUrl
        self.pathEnding = pathEnding
        self.customeHeaderParameters = customeHeaderParameters
    }
}
