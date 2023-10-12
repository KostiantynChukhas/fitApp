//
//  DataResponseBaseModel.swift
//  Networking
//

import Foundation

public class DataResponseBaseModel<ResponseDataType: Decodable & Equatable>: Decodable,
    ResponseBaseModelsProtocol
{
    
    public let message: String?
    private let code: Int?
    public let error: String?
    public let data: ResponseDataType?
    public let balance: ResponseDataType?
    public let count: Int?
    private let statusCode: Int?

    public let hasMore: Bool?
    
    public var serverStatusCode: Int? {
        guard code != nil else {
            return statusCode
        }
        return code
    }
    
    public var success: Bool {
        guard let code = serverStatusCode else { return false }
        return 200...299 ~= code
    }
    
    enum CodingKeys: String, CodingKey {
        case message, error, count, statusCode, data, balance, code, hasMore
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        message = try? container.decode(String.self, forKey: .message)
        code = try? container.decode(Int.self, forKey: .code)
        if let errorString = try? container.decode(String.self, forKey: .error) {
            error = errorString
        } else {
            error = try? container.decode(DataResponseErrorModel.self, forKey: .error).message.message
        }
        data = try? container.decode(ResponseDataType.self, forKey: .data)
        balance = try? container.decode(ResponseDataType.self, forKey: .balance)
        count = try? container.decode(Int.self, forKey: .count)
        statusCode = try? container.decode(Int.self, forKey: .statusCode)
        hasMore = try? container.decode(Bool.self, forKey: .hasMore)
    }

}

// MARK: - DataResponseErrorModel
struct DataResponseErrorModel: Decodable {
    let message: DataResponseErrorModelMessage
    let statusCode: Int
}

// MARK: - DataResponseErrorModelMessage
struct DataResponseErrorModelMessage: Decodable {
    let status: Int
    let message: String
}
