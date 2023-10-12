//
//  OnboardingResponseModel.swift
//  fitapp
//
// on 05.05.2023.
//

import Foundation

// MARK: - OnboardingResponseModel
struct OnboardingResponseModel: Codable, Equatable {
    let status: String?
    let code: Int
    let data: [OnboardingData]
}

// MARK: - Datum
struct OnboardingData: Codable, Equatable {
    let id: Int
    let picture: String
    let header, description: String
    let priority: Int
}
