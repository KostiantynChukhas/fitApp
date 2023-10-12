//
//  LibraryCommentsResponseModel.swift
//  fitapp
//
//  on 19.05.2023.
//

import Foundation

// MARK: - LibraryCommentsResponseModel
struct LibraryCommentsResponseModel: Codable, Equatable {
    let status: String?
    let code: Int?
    let data: [LibraryCommentsData]
}

// MARK: - Datum
struct LibraryCommentsData: Codable, Equatable, Hashable {
    let id: String?
    let modelAccount: ModelAccount?
    let answerCommentID: String?
    let comments: String?
    let countLike, countDislike: Int?
    let libraryID: String?
    let countAnswersComment: Int?
    let createdAt: String?
    var isLike, isDislike: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case modelAccount = "model_account"
        case answerCommentID = "answer_comment_id"
        case comments
        case countLike = "count_like"
        case countDislike = "count_dislike"
        case libraryID = "library_id"
        case countAnswersComment = "count_answers_comment"
        case createdAt
        case isLike = "is_like"
        case isDislike = "is_dislike"
    }
}

// MARK: - ModelAccount
struct ModelAccount: Codable, Equatable, Hashable {
    let id: String?
    let name: String?
    let email: String?
    let avatar: String?
    let role, createdAt: String?
    let emailConfirmation: Bool?
    let typeMetricSystem, activityLevel: String?
    let weight, height: Int?
    let dateBirth, gender: String?
//    let areasAttention: [String]?
    let motivatesMost: String?
    let typeRegister, typeAccount, aboutMe, achievements: String?
    let education, other: String?
    let modelTrainer: ModelTrainer?
    let goalWeight: Int?
    let notificationWorkout, notificationComments: Bool?
    let experience, country, city, gym: String?
    let myGoal, shortStory: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, avatar, role, createdAt
        case emailConfirmation = "email_confirmation"
        case typeMetricSystem = "type_metric_system"
        case activityLevel = "activity_level"
        case weight, height
        case dateBirth = "date_birth"
        case gender
//        case areasAttention = "areas_attention"
        case motivatesMost = "motivates_most"
        case typeRegister = "type_register"
        case typeAccount = "type_account"
        case aboutMe = "about_me"
        case achievements, education, other
        case modelTrainer = "model_trainer"
        case goalWeight = "goal_weight"
        case notificationWorkout = "notification_workout"
        case notificationComments = "notification_comments"
        case experience, country, city, gym
        case myGoal = "my_goal"
        case shortStory = "short_story"
    }
}

extension ModelAccount {
    func getAvatar() -> String {
        guard let replaceAvatar = avatar?.replacingOccurrences(of: "'\'", with: "") else { return "" }
        return replaceAvatar
    }
}

extension ModelAccount {
    var timeLabel: String {
        guard let createdAt, let time = Double(createdAt) else { return "" }
        return TimeAgo.timeAgoDisplay(date: Date(timeIntervalSince1970: time))
    }
}

extension LibraryCommentsData {
    var timeLabel: String {
        guard let createdAt, let time = Double(createdAt) else { return "" }
        return TimeAgo.timeAgoDisplay(date: Date(timeIntervalSince1970: time))
    }
}


