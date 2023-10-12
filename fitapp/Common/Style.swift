//
//  Style.swift
//  fitapp
//

import UIKit

class Style {
    
    // Enum for colors
    enum Color {
        case buttonColor
        case cinnabar
        case goldenrod
        case limedSpruce
        case textColor
        case nevada
        case osloGray
        case portage
        case regentStBlue
        case starship
        case silver
        case inactiveBorder
        case borderColor
        case lightTextColor
        case background
        case navigationColor
        case progressActiveColor
        case progressGrayColor
        case gradientColor
        
        var uiColor: UIColor {
            switch self {
            
            case .buttonColor:
                return UIColor(named: "Button Color") ?? .clear
            case .cinnabar:
                return UIColor(named: "Cinnabar") ?? .clear
            case .goldenrod:
                return UIColor(named: "Goldenrod") ?? .clear
            case .limedSpruce:
                return UIColor(named: "Limed Spruce") ?? .clear
            case .textColor:
                return UIColor(named: "Text Color") ?? .clear
            case .nevada:
                return UIColor(named: "Nevada") ?? .clear
            case .osloGray:
                return UIColor(named: "Oslo Gray") ?? .clear
            case .portage:
                return UIColor(named: "Portage") ?? .clear
            case .regentStBlue:
                return UIColor(named: "Regent St Blue") ?? .clear
            case .starship:
                return UIColor(named: "Starship") ?? .clear
            case .silver:
                return UIColor(named: "Silver") ?? .clear
            case .inactiveBorder:
                return UIColor(named: "Inactive Border") ?? .clear
            case .borderColor:
                return UIColor(named: "Border Color") ?? .clear
            case .lightTextColor:
                return UIColor(named: "Light Text Color") ?? .clear
            case .background:
                return UIColor(named: "Background") ?? .clear
            case .navigationColor:
                return UIColor(named: "Navigation color") ?? .clear
            case .progressActiveColor:
                return UIColor(named: "ProgressActiveColor") ?? .clear
            case .progressGrayColor:
                return UIColor(named: "ProgressGrayColor") ?? .clear
            case .gradientColor:
                return UIColor(named: "GradientColor") ?? .clear
            }
        }
    }
    
    // Enum for fonts
    enum Font {
        case latoMedium
        case latoSemibold
        case latoBold
        
        var uiFont: UIFont {
            switch self {
            case .latoMedium:
                return UIFont(name: "Lato-Medium", size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            case .latoSemibold:
                return UIFont(name: "Lato-Semibold", size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            case .latoBold:
                return UIFont(name: "Lato-Bold", size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            }
        }
    }
}
