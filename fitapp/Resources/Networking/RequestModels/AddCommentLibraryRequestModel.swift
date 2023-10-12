//
//  File.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 16.06.2023.
//

import Foundation
struct AddCommentLibraryRequestModel: Codable {
    let comments: String
    let library_id: String?
    let answer_comment_id: String?
    
    init(comments: String, library_id: String = "", answer_comment_id: String? = "") {
        self.comments = comments
        self.library_id = library_id
        self.answer_comment_id = answer_comment_id
    }
}
