//
//  TrainersResponseModel.swift
//  fitapp
//
//  Created by  on 23.07.2023.
//

import Foundation

struct TrainersResponseModel: Codable, Equatable {
    let status: String
    let code: Int
    let data: [TrainerData]
}

// MARK: - Datum
struct TrainerData: Codable, Equatable {
    let id, name, email: String
    let avatar: String
    let role, createdAt: String
    let emailConfirmation: Bool
    let typeMetricSystem, activityLevel, weight, height: Double?
    let dateBirth, gender, areasAttention, motivatesMost: String?
    let typeRegister, typeAccount, aboutMe, achievements: String
    let education, other: String
    let modelTrainer: ModelTrainer
    let goalWeight: Double?
    let notificationWorkout, notificationComments: Bool
    let experience: String
    let country: String?
    let city: String?
    let isMyLike: Bool
    
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
        case notificationWorkout = "notification_workout"
        case notificationComments = "notification_comments"
        case experience
        case city, country
        case isMyLike
    }
}

extension TrainerData {
    var isInfoHidden: Bool {
        return age == nil && country == nil && city == nil
    }
    
    var infoLabelText: String {
        var result = ""
        
        if let age = age, age != .zero {
            result.append("\(age) years")
        }
        
        if let city = city, !city.isEmpty {
            let delimeter = age != nil ? ", ": ""
            result.append("\(delimeter)\(city)")
        }
        
        if let country = country, !country.isEmpty {
            let delimeter = (age != nil || city != nil) ? ", ": ""
            result.append("\(delimeter)\(country)")
        }
        
        return result
    }
    
    var age: Int? {
        guard let dateBirth = dateBirth, let intTimestamp = Int(dateBirth) else { return nil }
        
        let timestamp: TimeInterval = TimeInterval(intTimestamp)
        let dateOfBirth = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year ?? 0
    }
}
