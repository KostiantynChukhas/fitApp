//
//  SettingType.swift
//  fitapp
//
//  Created by on 24.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

enum SettingType {
    case action(model: ActionCellModel)
    case switcher(model: SwitcherCellModel)
    case `default`(model: DefaultCellModel)
    case header(title: String)
    case spacer
}

enum ActionType {
    case logOut
    case deleteAccount
}

struct ActionCellModel {
    let action: ActionType
}

extension ActionType {
    var title: String {
        switch self {
        case .logOut:
            return "Log Out"
        case .deleteAccount:
            return "Delete my account"
        }
    }
    
    var image: String {
        switch self {
        case .logOut:
            return "SignOut"
        case .deleteAccount:
            return "Trash"
        }
    }
    
    var color: UIColor {
        switch self {
        case .logOut:
            return .black
        case .deleteAccount:
            return .red
        }
    }
}

enum SwitcherType {
    case publicProfile
    case displayMeasurements
    case workoutReminder
    case comments
}

struct SwitcherCellModel {
    let type: SwitcherType
    let isSelected: Bool
    
    let valueChanged = PublishRelay<Bool>()
    
    var valueChangedObserver: Observable<Bool> {
        return valueChanged.asObservable()
    }
}

extension SwitcherType {
    
    var title: String {
        switch self {
        case .publicProfile:
            return "Public Profile"
        case .displayMeasurements:
            return "Display my measurements"
        case .workoutReminder:
            return "Workout reminder"
        case .comments:
            return "Comments"
        }
    }
    
    var image: String {
        switch self {
        case .publicProfile:
            return "ChartBar"
        case .displayMeasurements:
            return "ChartBar"
        case .workoutReminder:
            return "Barbell"
        case .comments:
            return "ChatCircleDots"
        }
    }
    
}

enum DefaultType {
    case setUnit
    case contactUs
    case rateTheApp
    case privacyPolicy
    case termsOfUse
}

struct DefaultCellModel {
    let type: DefaultType
}

extension DefaultType {
    var title: String {
        switch self {
        case .setUnit:
            return "Set Units"
        case .contactUs:
            return "Contact Us"
        case .rateTheApp:
            return "Rate the app"
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfUse:
            return "Terms of Use"
        }
    }
    
    var image: String {
        switch self {
        case .setUnit:
            return "ic_measurement"
        case .contactUs:
            return "CircleWavyQuestion"
        case .rateTheApp:
            return "ic_setting_star"
        case .privacyPolicy:
            return "ShieldWarning"
        case .termsOfUse:
            return "ClipboardText"
        }
    }
}
