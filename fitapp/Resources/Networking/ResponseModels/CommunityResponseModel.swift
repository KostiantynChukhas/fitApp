//
//   CommunityResponseModel.swift
//  fitapp
//
//  on 21.05.2023.
//

import Foundation

// MARK: - CommunityResponseModel
struct CommunityResponseModel: Codable, Equatable {
    let status: String
    let code: Int
    let data: CommunityData?
}

// MARK: - DataClass
struct CommunityData: Codable, Equatable {
    let id, description: String?
    let countLike, countDislike, countComments: Int?
    let picture: [String]?
    let createdAt: String?
    let modelAccount: ModelAccount?

    enum CodingKeys: String, CodingKey {
        case id, description
        case countLike = "count_like"
        case countDislike = "count_dislike"
        case countComments = "count_comments"
        case picture, createdAt
        case modelAccount = "model_account"
    }
}

