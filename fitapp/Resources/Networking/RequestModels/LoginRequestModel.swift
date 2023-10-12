//
//  LoginRequestModel.swift
//  fitapp
//
//   on 05.05.2023.
//

import Foundation

struct LoginRequestModel: Codable {
    let email: String
    let password: String
    let meta: String = UUID.uuid
}
