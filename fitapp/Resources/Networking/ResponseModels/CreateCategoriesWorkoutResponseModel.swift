//
//  CreateCategoriesWorkoutResponseModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 22.07.2023.
//

import Foundation
// MARK: - CreateCategoriesWorkoutResponseModel
struct CategoriesWorkoutResponseModel: Codable, Equatable {
    let status: String?
    let code: Int?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable, Equatable {
    let id: Int?
    let name, description: String?
    let picture: String?
    let createdAt, updatedAt: String?
}

