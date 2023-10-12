//
//  RegistrationRequestModel.swift
//  fitapp
//
// on 06.05.2023.
//

import Foundation
struct RegistrationRequestModel: Codable {
    let email: String
    let password: String
    var meta: String = UUID.uuid
}
