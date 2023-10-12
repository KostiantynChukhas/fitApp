//
//  UploadDataDraftCommunityRequestModel.swift
//  fitapp
//
//  on 24.05.2023.
//

import Foundation

struct UploadDataDraftCommunityRequestModel: Codable {
    let description: String?
    let id_community: String
    let image: Data?
    let video: Data?
}


