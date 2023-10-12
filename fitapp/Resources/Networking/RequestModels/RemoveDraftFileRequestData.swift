//
//  RemoveDraftFileRequestData.swift
//  fitapp
//
//  Created by Sergey Pritula on 14.08.2023.
//

import Foundation

struct RemoveDraftFileRequestData: Codable {
    let id_community: String
    let file_url: String
    let description: String
    
    init(id_community: String, file_url: String) {
        self.id_community = id_community
        self.file_url = file_url
        self.description = "test"
    }
}
