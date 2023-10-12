//
//  LimitRequestData.swift
//  fitapp
//
//  Created by  on 21.06.2023.
//

import Foundation

struct LimitRequestData: Codable {
    let limit: Int
}

struct CreatedAtRequestData: Codable {
    var createdAtLast: Int
}

