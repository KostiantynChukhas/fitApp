//
//  CreateLikeCommunityRequestModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 27.06.2023.
//

import Foundation

struct CreateLikeCommunityRequestModel: Codable {
    let community_id: String
    let is_like: Bool
}


struct CreateDislikeCommunityRequestModel: Codable {
    let community_id: String
    let is_dislike: Bool
}

struct CreateLikeCommentRequestModel: Codable {
    let comment_id: String
    let is_like: Bool
}


struct CreateDislikeCommentRequestModel: Codable {
    let comment_id: String
    let is_dislike: Bool
}

