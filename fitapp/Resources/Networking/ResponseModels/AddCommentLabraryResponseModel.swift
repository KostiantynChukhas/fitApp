//
//  AddCommentLabraryResponseModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 16.06.2023.
//

import Foundation

// MARK: - CommunityCommentsResponseModel
struct AddCommentLabraryResponseModel: Codable, Equatable {
    let status: String?
    let code: Int?
    let data: LibraryCommentsData?
}
