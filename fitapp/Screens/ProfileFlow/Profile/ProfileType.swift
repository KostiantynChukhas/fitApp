//
//  ProfileType.swift
//  fitapp
//
//

import Foundation

enum ProfileType {
    case trainer(model: TrainerData)
    case ownProfile(model: UserData)
    case userProfile(model: UserData)
}

extension ProfileType {
    var isOwn: Bool {
        switch self {
        case .trainer, .userProfile:
            return false
        case .ownProfile:
            return true
        }
    }
    
    var isTrainer: Bool {
        switch self {
        case .trainer:
            return true
        case .ownProfile, .userProfile:
            return false
        }
    }
    
    var id: String {
        switch self {
        case .trainer(let model):
            return model.id
        case .ownProfile(let model), .userProfile(let model):
            return model.id
        }
    }
    
    var isPrivate: Bool {
        switch self {
        case .trainer:
            return false
        case .ownProfile:
            return false
        case .userProfile(let model):
            return model.typeAccount == .privateAccount
        }
    }
}
