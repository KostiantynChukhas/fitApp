//
//  CummunityCommentsRequestModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 14.06.2023.
//

import Foundation

struct CommunityCommentsRequestModel: Codable {
    let limit: Int
    let community_id: String
    let createdAtLast: String
    let answer_comment_id: String
    
    init(limit: Int = 30, community_id: String, answer_comment_id: String = "", createdAtLast: String = "") {
        self.limit = limit
        self.community_id = community_id
        self.createdAtLast = createdAtLast
        self.answer_comment_id = answer_comment_id
    }
}
