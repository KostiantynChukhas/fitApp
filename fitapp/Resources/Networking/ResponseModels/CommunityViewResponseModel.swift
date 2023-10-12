//
//  CommunityViewResponseModel.swift
//  fitapp
//
//  on 26.05.2023.
//

import Foundation
// MARK: - CommunityViewResponseModel
struct CommunityViewResponseModel: Codable, Equatable {
    let status: String
    let code: Int
    let data: [CommunityViewData]
}

// MARK: - Datum
struct CommunityViewData: Codable, Equatable, Hashable {
    static func == (lhs: CommunityViewData, rhs: CommunityViewData) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id, description: String?
    var countLike, countDislike, countComments: Int?
    let files: [String]?
    let createdAt: String?
    let modelAccount: ModelAccount?
    let release: Bool?
    let publicationDate: String?
    var isLike, isDislike: Bool?

    enum CodingKeys: String, CodingKey {
        case id, description
        case countLike = "count_like"
        case countDislike = "count_dislike"
        case countComments = "count_comments"
        case files, createdAt
        case modelAccount = "model_account"
        case release
        case publicationDate = "publication_date"
        case isLike = "is_like"
        case isDislike = "is_dislike"
    }
}
