//
//  TellUsCellViewModel.swift
//  fitapp
//
// on 09.05.2023.
//

import Foundation
class TellUsCellViewModel {
    var gender: Gender
    
    init(gender: Gender) {
        self.gender = gender
    }
}

enum Gender: String, Codable {
    case male = "male"
    case female = "female"
    case none = "none"
    
    func getGender(from: String) -> Gender {
        if let result = Gender(rawValue: from) {
            return result
        } else {
            guard let gender = SessionManager.shared.user?.gender else { return .none }
            return Gender(rawValue: gender) ?? .none
        }
    }
}
