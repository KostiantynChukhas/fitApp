//
//  EditCategoriesWorkoutRequestModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 22.07.2023.
//

import Foundation

struct EditCategoriesWorkoutRequestModel: Codable {
    let id_categories: Int
    let name : String
    let description: String
    
}

struct DeleteCategoriesWorkoutRequestModel: Codable {
    let id_categories: Int
    let name : String
    
}
