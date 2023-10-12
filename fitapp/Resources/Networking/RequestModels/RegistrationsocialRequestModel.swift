//
//  RegistrationsocialRequestModel.swift
//  fitapp
//
// on 08.05.2023.
//

import Foundation

enum TypeRegister: String, Codable {
    case apple = "APPLE"
    case google = "GOOGLE"
    case facebook = "FACEBOOK"
    case email = "EMAIL"
}

struct RegistrationSocialRequestModel: Codable {
    let access_token: String
    let type_register: TypeRegister
    var meta: String = UUID.uuid
}
