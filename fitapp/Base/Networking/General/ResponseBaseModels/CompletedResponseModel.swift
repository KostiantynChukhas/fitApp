//
//  CompletedResponseModel.swift
//  Networking
//

import Foundation

internal class CompletedResponseModel: Decodable, ResponseBaseModelsProtocol {
    var count: Int?
    let code: Int?
    let message: String?
    let error: String?
    let statusCode: Int?

    var serverStatusCode: Int? {
        guard code != nil else {
            return statusCode
        }
        return code
    }
}
