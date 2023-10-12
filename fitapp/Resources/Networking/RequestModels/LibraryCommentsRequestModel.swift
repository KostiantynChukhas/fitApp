//
//  LibraryCommentsRequestModel.swift
//  fitapp
//
//  on 19.05.2023.
//

import Foundation

struct LibraryCommentsRequestModel: Codable {
    let limit: Int?
    let library_id: String
    let answer_comment_id: String?
    let createdAtLast: String?
    
    init(limit: Int? = 20, library_id: String, answer_comment_id: String? = "", createdAtLast: String? = "") {
        self.limit = limit
        self.library_id = library_id
        self.answer_comment_id = answer_comment_id
        self.createdAtLast = createdAtLast
    }
}

