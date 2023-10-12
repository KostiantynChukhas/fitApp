//
//  CreateCategoriesWorkoutRequestModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 22.07.2023.
//

import Foundation

struct CreateCategoriesWorkoutRequestModel: Codable {
    let description: String
    let name: String
    let picture: Data?
}



