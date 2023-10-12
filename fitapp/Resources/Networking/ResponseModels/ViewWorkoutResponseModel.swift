//
//  ViewWorkoutResponseModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 22.07.2023.
//

import Foundation

// MARK: - ViewWorkoutResponseModel
struct ViewWorkoutResponseModel: Codable, Equatable {
    let status: String
    let code: Int
    let data: [ViewWorkoutData]?
}

// MARK: - Datum
struct ViewWorkoutData: Codable, Equatable {
    let id, header, typeSortWorkout: String?
    let modelCategories: [ModelCategory]?
    let isActive: Bool?
    let picture: String?
    let createdAt: String?
    let modelTraining: [ModelTraining]?
    let modelWorkoutSort: ModelWorkoutSort?
    let countDays: Int
    
    enum CodingKeys: String, CodingKey {
        case id, header
        case typeSortWorkout = "type_sort_workout"
        case modelCategories = "model_categories"
        case modelWorkoutSort = "model_workout_sort"
        case isActive = "is_active"
        case picture, createdAt
        case modelTraining = "model_training"
        case countDays = "count_days"
    }
}

struct ModelWorkoutSort: Codable, Equatable {
    let id: Int
    let name: String
    let stars: Int
    let type: String
    let picture: String
}

// MARK: - ModelTraining
struct ModelTraining: Codable, Equatable {
    let id: Int?
    let workoutID, header: String?
    let description: String?
    let day: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case workoutID = "workout_id"
        case header, description, day, createdAt
    }
}
