//
//  ViewWorkoutRequestModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 22.07.2023.
//

import Foundation

struct ViewWorkoutRequestModel: Codable {
    let limit: Int
    let categories: String
    let createdAtLast: String?
}


