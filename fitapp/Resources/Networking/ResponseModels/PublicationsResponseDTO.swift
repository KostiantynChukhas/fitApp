//
//  PublicationsResponseDTO.swift
//  fitapp
//
//  Created by  on 22.06.2023.
//

import Foundation
import UIKit

// MARK: - PublicationsResponse
struct PublicationsResponseDTO: Codable, Equatable {
    let status: String
    let code: Int
    let data: [Data]
    
    // MARK: - Datum
    struct Data: Codable, Equatable {
        let id: String
        let url: String?
        let type: String?
        let modelAccount: ModelAccount?
        let header, createdAt: String?

        enum CodingKeys: String, CodingKey {
            case id, url, type
            case modelAccount = "model_account"
            case header, createdAt
        }
        
        func toPhotoModel() -> PhotoModelUrl {
            .init(uuid: id, imageUrl: url)
        }
    }

    // MARK: - ModelAccount
    struct ModelAccount: Codable, Equatable {
        let id: String
        let name: String?
        let email: String?
        let avatar: String?
        let role, createdAt: String?
        let emailConfirmation: Bool?
        let typeMetricSystem, activityLevel: String?
        let weight, height: Int?
        let dateBirth, gender: String?
        let areasAttention: [String]?
        let motivatesMost, typeRegister, typeAccount, country: String?
        let city, gym, myGoal, shortStory: String?
        let goalWeight: Int?
        let notificationWorkout, notificationComments: Bool?
        let experience: String?

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
            case typeRegister = "type_register"
            case typeAccount = "type_account"
            case country, city, gym
            case myGoal = "my_goal"
            case shortStory = "short_story"
            case goalWeight = "goal_weight"
            case notificationWorkout = "notification_workout"
            case notificationComments = "notification_comments"
            case experience
        }
    }
}
