//
//  UserServiceType.swift
//  fitapp
//

import Foundation

enum FitAppResult<T> {
    case failure(FitAppError)
    case success(T)
}

enum SimpleResult {
    case failure(message: String)
    case success
}

enum AuthResult: Decodable {
    case cancel
    case failure(message: String)
    case success
}

