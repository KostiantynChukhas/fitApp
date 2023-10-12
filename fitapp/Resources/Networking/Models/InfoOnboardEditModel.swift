//
//  InfoOnboardEditModel.swift
//  fitapp
//
// on 05.05.2023.
//

import Foundation
// MARK: - InfoOnboardEditModel
struct InfoOnboardEditModel: Codable {
    let status: String?
    let code: Int?
    let data: InfoOnboardData?
}

// MARK: - DataClass
struct InfoOnboardData: Codable {
    let id: String?
    let name: String?
    let email: String?
    let avatar: String?
    let role, createdAt: String?
    let emailConfirmation: Bool?
    let typeMetricSystem, activityLevel: String?
    let weight, height: Int?
    let dateBirth, gender: String?
    let areasAttention: [String]?
    let motivatesMost: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, avatar, role, createdAt
        case emailConfirmation = "email_confirmation"
        case typeMetricSystem = "type_metric_system"
        case activityLevel = "activity_level"
        case weight, height
        case dateBirth = "date_birth"
        case gender
        case areasAttention = "areas_attention"
        case motivatesMost = "motivates_most"
    }
}

