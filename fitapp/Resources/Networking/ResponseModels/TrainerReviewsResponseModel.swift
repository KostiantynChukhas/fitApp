//
//  TrainerReviewsResponseModel.swift
//  fitapp
//
//

import Foundation

// MARK: - TrainerReviewResponse
struct TrainerReviewResponse: Codable, Equatable {
    let status: String
    let code: Int
    let data: [TrainerReviewData]
}

// MARK: - Datum
struct TrainerReviewData: Codable, Equatable {
    let id: Int
    let trainerID, accountID: String
    let star: Int
    let description: String
    let picture: [String]?
    let createdAt: String
    let modelAccount: ModelAccount

    enum CodingKeys: String, CodingKey {
        case id
        case trainerID = "trainer_id"
        case accountID = "account_id"
        case star, description, picture, createdAt
        case modelAccount = "model_account"
    }
    
    var date: String {
        guard let intTimestamp = Int(createdAt) else { return "" }
        
        let timestamp: TimeInterval = TimeInterval(intTimestamp)
        let date = Date(timeIntervalSince1970: timestamp)
        
        let formattedDate = formatDate(date, toFormat: "dd.MM.yyyy")
        return formattedDate
    }
}
