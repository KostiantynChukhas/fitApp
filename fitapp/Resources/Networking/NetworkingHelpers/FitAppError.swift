//
//  FitAppError.swift
//  fitapp
//

import Foundation


struct FitAppCustomError: Codable, LocalizedError {
    let status: String
    let code: Int
    let error: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case status, code, error
    }
    
    var errorDescription: String? {
        return error.values.first
    }
}

@objcMembers
class FitAppError: NSObject, Codable, LocalizedError {
    
    var title: String?
    var message: String
    var code: Int?
    
    init(code: Int? = nil, title: String? = nil, message: String) {
        self.code = code
        self.title = title
        self.message = message
    }
    
    init(message: String) {
        self.message = message
    }
    
    static func somethingWentWrongError() -> FitAppError {
        return FitAppError(title: "", message: "Oh no! Looks like something is wrong. Please wait a few minutes and try again.")
    }
    
    override public var description: String {
        return "Title: \(title ?? ""), Message: \(message)"
    }
    
    var errorDescription: String? {
        return message
    }

}


