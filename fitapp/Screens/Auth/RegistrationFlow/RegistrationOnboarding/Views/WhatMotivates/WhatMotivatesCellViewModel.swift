//
//  WhatMotivatesCellViewModel.swift
//  fitapp
//
// on 09.05.2023.
//

import Foundation


class WhatMotivatesCellViewModel {
    enum TypeCells {
        case motivates
        case activity
    }
    
    var type: TypeMotivatesMost
    var typeActivity: TypeActivityLevel
    var typeCell: TypeCells
    
    init(cellType: TypeCells, type: TypeMotivatesMost, typeActivity: TypeActivityLevel) {
        self.typeCell = cellType
        self.type = type
        self.typeActivity = typeActivity
    }
}

//MARK: - TypeMotivatesMost -

enum TypeMotivatesMost: String {
    case feelingConfident = "FEELING_CONFIDENT"
    case beingNoticed = "BEING_NOTICED"
    case beingActive = "BEING_ACTIVE"
    case gainingMuscle = "GAINING_MUSCL"
    case none = "none"
}

enum TypeActivityLevel: String {
    case inactive =          "INACTIVE"
    case moderatelyActive =  "MODERATELY_ACTIVE"
    case active =            "ACTIVE"
    case veryActive =        "VERY_ACTIV"
    case none = "none"
}
