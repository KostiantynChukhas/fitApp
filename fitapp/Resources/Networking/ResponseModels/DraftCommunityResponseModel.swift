//
//  DraftCommunityResponseModel.swift
//  fitapp
//
//  on 24.05.2023.
//

import Foundation
// MARK: - DraftCommunityResponseModel
struct DraftCommunityResponseModel: Codable, Equatable {
    let status: String?
    let code: Int?
    let data: DraftData?
}

// MARK: - DataClass
struct DraftData: Codable, Equatable {
    static func == (lhs: DraftData, rhs: DraftData) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id, description: String?
    let countLike, countDislike, countComments: Int?
    let files: [String]?
    let createdAt: String?
    let modelAccount: ModelAccount?
    let release: Bool?
    let publicationDate: String?

    enum CodingKeys: String, CodingKey {
        case id, description
        case countLike = "count_like"
        case countDislike = "count_dislike"
        case countComments = "count_comments"
        case files, createdAt
        case modelAccount = "model_account"
        case release
        case publicationDate = "publication_date"
    }
}

extension DraftData {
    func getFiles() -> [String] {
        var replacedURLs = [String]()
        guard let files = files else { return [] }

        for url in files {
            let replacedURL = url.replacingOccurrences(of: "/", with: "")
            replacedURLs.append(replacedURL)
        }

        return replacedURLs
    }
}
