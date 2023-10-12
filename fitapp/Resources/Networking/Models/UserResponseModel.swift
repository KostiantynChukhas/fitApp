//
//  LoginResponseModel.swift
//  fitapp
//

import Foundation
// MARK: - LoginResponseModel
struct UserResponseModel: Codable, Equatable {
    let status: String
    let code: Int
    let data: UserData?
    let error: LoginError?
}

struct UserData: Codable, Equatable {
    let id: String
    let name: String?
    let email: String?
    let avatar: String?
    let token: String?
    let role: Role?
    let createdAt: String?
    let emailConfirmation: Bool?
    var typeMetricSystem, activityLevel: String?
    let weight, height: Int?
    let dateBirth, gender: String?
    let areasAttention: [String]?
    let motivatesMost, typeRegister, country: String?
    var typeAccount: TypeAccount?
    let city, gym, myGoal, shortStory: String?
    let goalWeight: Int?
    let isOnboardFinished: Bool?
    var notificationWorkout, notificationComments: Bool?
    let experience: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, avatar, role, createdAt, token
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
        case isOnboardFinished = "is_onboard_finished"
        case notificationWorkout = "notification_workout"
        case notificationComments = "notification_comments"
        case experience
    }
    
    static var empty = UserData(
        id: "",
        name: nil,
        email: nil,
        avatar: nil,
        token: nil,
        role: nil,
        createdAt: nil,
        emailConfirmation: nil,
        typeMetricSystem: nil,
        activityLevel: nil,
        weight: nil,
        height: nil,
        dateBirth: nil,
        gender: nil,
        areasAttention: nil,
        motivatesMost: nil,
        typeRegister: nil,
        country: nil,
        typeAccount: nil,
        city: nil,
        gym: nil,
        myGoal: nil,
        shortStory: nil,
        goalWeight: nil,
        isOnboardFinished: nil,
        notificationWorkout: nil,
        notificationComments: nil,
        experience: nil
    )
}

enum TypeAccount: String, Codable {
    case privateAccount = "PRIVATE"
    case publicAccount = "PUBLIC"
}

// MARK: - Error
struct LoginError: Codable, Equatable {
    let email: String?
}

enum Role: String, Codable {
    case admin = "ADMIN"
    case trainer = "TRAINER"
    case user = "USER"
}


extension UserData {
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
