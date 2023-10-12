//
//  LibraryRequestModel.swift
//  fitapp
//
//  on 16.05.2023.
//

import Foundation
struct LibraryRequestModel: Codable {
    let limit: Int
    let categories: String
    let createdAtLast: String
    let search: String?
}
