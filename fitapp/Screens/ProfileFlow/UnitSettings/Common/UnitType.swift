//
//  UnitType.swift
//  fitapp
//
//  Created by on 23.05.2023.
//

import Foundation

enum UnitType {
    case weight
    case height
}

extension UnitType {
    var title: String {
        switch self {
        case .weight:
            return "Weight"
        case .height:
            return "Height"
        }
    }
    
    func getLeftTitle() -> String {
        switch self {
        case .weight:
            return UnitSystemType.eu.weightTitle
        case .height:
            return UnitSystemType.eu.sizeTitle
        }
    }
    
    func getRightTitle() -> String {
        switch self {
        case .weight:
            return UnitSystemType.usa.weightTitle
        case .height:
            return UnitSystemType.usa.sizeTitle
        }
    }
    
}
