//
//  ErrorModel.swift
//  fitapp
//

import Foundation

struct ErrorModel: Codable {
    let messages: [String]
}

extension ErrorModel {
    
    var errorStr: String {
        if !messages.isEmpty {
            return messages.joined(separator: "\n")
        }
        
        return FitAppError.somethingWentWrongError().message
    }
}
