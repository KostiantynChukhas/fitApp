//
//  WatsYourCurrentWeightCellViewModel.swift
//  fitapp
//
// on 09.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class WatsYourCurrentWeightCellViewModel {
    var type: TypeMetricSystem
    let typeCells: TypeWeightCell
    let typeObservable: BehaviorRelay<TypeMetricSystem>
    
    var weight: Int
    var goalWeight: Int
    var height: Int
    
    init(type: TypeMetricSystem, typeCells: TypeWeightCell, user: UserData) {
        self.type = type
        self.typeCells = typeCells
        
        self.weight = user.weight ?? .zero
        self.goalWeight = Int(user.myGoal ?? "0") ?? .zero
        self.height = user.height ?? .zero
        
        self.typeObservable = BehaviorRelay<TypeMetricSystem>(value: type)
    }
    
}

//MARK: - AnthropometryModel -

enum TypeWeightCell {
    case currentWeight
    case goalWeight
    case currentHeight
}

enum TypeMetricSystem: String {
    case Eu = "EU"
    case Usa = "USA"
}

