//
//  TellAboutYourselfCellViewModel.swift
//  fitapp
//
// on 09.05.2023.
//

import Foundation

class TellAboutYourselfCellViewModel {
    var type: [BodyType]
    var gender: Gender
    
    init(type: [BodyType], gender: Gender) {
        self.type = type
        self.gender = gender
    }
}


//MARK: - BodyType -

enum BodyType: String, CaseIterable {
    case arms = "ARMS"
    case chest = "CHEST"
    case back = "BACK"
    case abs = "ABS"
    case legs = "LEG"
}
