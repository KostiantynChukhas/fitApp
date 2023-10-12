//
//  RegistrationOnboardingModels.swift
//  fitapp
//
// on 09.05.2023.
//

import Foundation
import RxDataSources

enum ExploreSectionModel: SectionModelType {
    case tellUs(items: [RegistrationOnboardingType])
    case tellAboutYourself(items: [RegistrationOnboardingType])
    case whatMotivates(items: [RegistrationOnboardingType])
    case whatsYourName(items: [RegistrationOnboardingType])
    case whatsYourBirth(items: [RegistrationOnboardingType])
    case whatsYourCurrentWeight(items: [RegistrationOnboardingType])
}

enum RegistrationOnboardingType {
    case tellUs(model: TellUsCellViewModel)
    case tellAboutYourself(model: TellAboutYourselfCellViewModel)
    case whatMotivates(model: WhatMotivatesCellViewModel)
    case whatsYourName(model: WhatsYourNameCellViewModel)
    case whatsYourBirth(model: WatsYourBirthCellViewModel)
    case whatsYourCurrentWeight(model: WatsYourCurrentWeightCellViewModel)
}

extension ExploreSectionModel {
    typealias Item = RegistrationOnboardingType
    
    var items: [RegistrationOnboardingType] {
        switch self {
        
        case .tellUs(items: let items):
            return items.map { $0 }
        case .tellAboutYourself(items: let items):
            return items.map { $0 }
        case .whatMotivates(items: let items):
            return items.map { $0 }
        case .whatsYourName(items: let items):
            return items.map { $0 }
        case .whatsYourBirth(items: let items):
            return items.map { $0 }
        case .whatsYourCurrentWeight(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: ExploreSectionModel, items: [RegistrationOnboardingType]) {
        switch original {
      
        case .tellUs(items: _): self = .tellUs(items: items)
        case .tellAboutYourself(items: _):  self = .tellAboutYourself(items: items)
        case .whatMotivates(items: _): self = .whatMotivates(items: items)
        case .whatsYourName(items: _): self = .whatsYourName(items: items)
        case .whatsYourBirth(items: _): self = .whatsYourBirth(items: items)
        case .whatsYourCurrentWeight(items: _): self = .whatsYourCurrentWeight(items: items)
        }
    }
}
