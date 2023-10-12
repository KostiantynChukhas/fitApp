//
//  AddCommentCommunityRequestModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 15.06.2023.
//

import Foundation
struct AddCommentCommunityRequestModel: Codable {
    let comments: String
    let community_id: String?
    let answer_comment_id: String?
    
    init(comments: String, community_id: String = "", answer_comment_id: String? = "") {
        self.comments = comments
        self.community_id = community_id
        self.answer_comment_id = answer_comment_id
    }
}


