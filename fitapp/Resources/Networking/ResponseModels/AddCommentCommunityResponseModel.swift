//
//  AddCommentCommunityResponseModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 15.06.2023.
//

import Foundation

// MARK: - CommunityCommentsResponseModel
struct AddCommentCommunityResponseModel: Codable, Equatable {
    let status: String?
    let code: Int?
    let data: CommunityCommentsData?
}
