//
//  UnitType.swift
//  fitapp
//
//  Created by on 23.05.2023.
//

import Foundation

enum UnitSystemType: String {
    case eu
    case usa
}

extension UnitSystemType {
    var sizeTitle: String {
        switch self {
        case .eu:
            return "cm"
        case .usa:
            return "inch"
        }
    }
    
    var weightTitle: String {
        switch self {
        case .eu:
            return "kg"
        case .usa:
            return "lb"
        }
    }
    
    
}
