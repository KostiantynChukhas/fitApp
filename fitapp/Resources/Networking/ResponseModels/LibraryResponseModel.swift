//
//  LibraryResponseModel.swift
//  fitapp
//
//  on 16.05.2023.
//

import Foundation

// MARK: - LibraryResponseModel
struct LibraryResponseModel: Codable, Equatable {
    let status: String
    let code: Int
    let data: [LibraryData]
}

// MARK: - Datum
struct LibraryData: Codable, Equatable {
    let id, header: String
    let picture: String
    let content: String
    let modelCreator: ModelCreator
    let modelCategories: [ModelCategory]
    let createdAt: String
    let isActive: Bool
    let isSave: Bool

    enum CodingKeys: String, CodingKey {
        case id, header, picture, content
        case modelCreator = "model_creator"
        case modelCategories = "model_categories"
        case createdAt
        case isActive = "is_active"
        case isSave = "is_save"
    }
}

// MARK: - ModelCategory
struct ModelCategory: Codable, Equatable {
    let id: Int
    let name: String
    let picture: String
    let createdAt: String
}

// MARK: - ModelCreator
struct ModelCreator: Codable, Equatable {
    let id, name, email: String?
    let avatar: String?
    let role, createdAt: String?
    let emailConfirmation: Bool?
    let typeMetricSystem, activityLevel: String?
    let weight, height: Int?
    let dateBirth, gender, areasAttention, motivatesMost: String?
    let typeRegister, typeAccount, aboutMe, achievements: String?
    let education, other: String?
    let modelTrainer: ModelTrainer?
    let goalWeight: String?
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
        case aboutMe = "about_me"
        case achievements, education, other
        case modelTrainer = "model_trainer"
        case goalWeight = "goal_weight"
        case experience
    }
}

// MARK: - ModelTrainer
struct ModelTrainer: Codable, Equatable, Hashable  {
    let trainerActive: Bool
    let countLike: Int
    let trainerExperience: String
    let count5_Star, count4_Star, count3_Star, count2_Star, count1_Star: Int

    var max: Int {
        return [count5_Star, count4_Star, count3_Star, count2_Star, count1_Star].max() ?? .zero
    }
    
    var count1_progress: Float {
        return Float(count1_Star) / Float(max)
    }
    
    var count2_progress: Float {
        return Float(count2_Star) / Float(max)
    }
    
    var count3_progress: Float {
        return Float(count3_Star) / Float(max)
    }
    
    var count4_progress: Float {
        return Float(count4_Star) / Float(max)
    }
    
    var count5_progress: Float {
        return Float(count5_Star) / Float(max)
    }
    
    enum CodingKeys: String, CodingKey {
        case trainerActive = "trainer_active"
        case countLike = "count_like"
        case trainerExperience = "trainer_experience"
        case count5_Star = "count_5_star"
        case count4_Star = "count_4_star"
        case count3_Star = "count_3_star"
        case count2_Star = "count_2_star"
        case count1_Star = "count_1_star"
    }
}

