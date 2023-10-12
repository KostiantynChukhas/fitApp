//
//  AuthorizationTokenProvider.swift
//  Networking
//

import Foundation

public protocol AuthorizationTokenProvider {
    func authorizationToken() -> String?
}
