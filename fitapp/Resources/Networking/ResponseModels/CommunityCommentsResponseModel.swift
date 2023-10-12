//
//  CommunityCommentsResponseModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 14.06.2023.
//

import Foundation

// MARK: - CommunityCommentsResponseModel
struct CommunityCommentsResponseModel: Codable, Equatable {
    let status: String?
    let code: Int?
    let data: [CommunityCommentsData]?
}

// MARK: - Datum
struct CommunityCommentsData: Codable, Equatable {
    let id: String?
    let modelAccount: ModelAccount?
    let comments: String?
    let answerCommentID: String?
    let countLike, countDislike, countAnswersComment: Int?
    let createdAt: String?
    var isLike, isDislike: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case modelAccount = "model_account"
        case comments
        case answerCommentID = "answer_comment_id"
        case countLike = "count_like"
        case countDislike = "count_dislike"
        case countAnswersComment = "count_answers_comment"
        case createdAt
        case isLike = "is_like"
        case isDislike = "is_dislike"
    }
}

extension CommunityCommentsData {
    var timeLabel: String {
        guard let createdAt, let time = Double(createdAt) else { return "" }
        return TimeAgo.timeAgoDisplay(date: Date(timeIntervalSince1970: time))
    }
}
