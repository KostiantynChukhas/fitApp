//
//  TrainerReviewRequestData.swift
//  fitapp
//

import Foundation

struct TrainerReviewRequestData: Codable {
    let trainerId: String
    
    enum CodingKeys: String, CodingKey {
        case trainerId = "trainer_id"
    }
}




