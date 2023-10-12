//
//  CreateTrainerReviewRequestData.swift
//  fitapp
//
//

import Foundation

struct CreateTrainerReviewRequestData: Codable {
    let description: String
    let star: Int
    let trainerId: String
    let picture: [Data]
    
    enum CodingKeys: String, CodingKey {
        case description, star, picture
        case trainerId = "trainer_id"
    }
}




