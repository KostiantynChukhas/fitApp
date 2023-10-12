//
//  CreateLikeCommunityResponseModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 27.06.2023.
//

import Foundation

struct CreateLikeCommunityResponseModel: Codable, Equatable {
    let status: String
    let code: Int
    let data: String
    
    static var failure = CreateLikeCommunityResponseModel(status: "", code: -1, data: "")
}
