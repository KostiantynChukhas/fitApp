//
//  UnitSettingCellViewModel.swift
//  fitapp
//
//  Created by on 23.05.2023.
//

import Foundation
import RxSwift

class UnitSettingCellViewModel {
    var unitType: UnitType
    var selectedSystemType: UnitSystemType
    var isEditable: Bool
    
    var didSelectType = PublishSubject<UnitSystemType>()
    
    init(unitType: UnitType, selectedSystemType: UnitSystemType, isEditable: Bool) {
        self.unitType = unitType
        self.selectedSystemType = selectedSystemType
        self.isEditable = isEditable
    }
}
