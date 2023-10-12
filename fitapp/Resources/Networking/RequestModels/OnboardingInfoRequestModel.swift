//
//  OnboardingInfoRequestModel.swift
//  fitapp
//
// on 05.05.2023.
//

import Foundation

struct OnboardingInfoRequestModel: Codable {
    let gender: String?
    let motivates_most: String?
    let areas_attention: [String]?
    let activity_level: String?
    let type_metric_system: String?
    let weight: Int?
    let height: Int?
    let date_birth: Double?
    let goal_weight: Int?
    
    init(gender: String? = nil,
         motivates_most: String? = nil,
         areas_attention: [String]? = nil,
         activity_level: String? = nil,
         type_metric_system: String? = nil,
         weight: Int? = nil,
         height: Int? = nil,
         date_birth: Double? = nil,
         goal_weight: Int? = nil) {
        
        self.gender = gender
        self.motivates_most = motivates_most
        self.areas_attention = areas_attention
        self.activity_level = activity_level
        self.type_metric_system = type_metric_system
        self.weight = weight
        self.height = height
        self.date_birth = date_birth
        self.goal_weight = goal_weight
    }
}

