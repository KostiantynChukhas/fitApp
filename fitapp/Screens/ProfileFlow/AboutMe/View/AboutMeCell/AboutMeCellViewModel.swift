//
//  AboutMeCellViewModel.swift
//  fitapp
//
//  Created by on 25.05.2023.
//

import Foundation
enum AboutMeType {
    case country
    case city
    case gym
    case experience
    case myGoal
    case shortStory
    case aboutMe
    case achievements
    case education
    case other
    
    var title: String {
        switch self {
        case .country:
            return "Country"
        case .city:
            return "City"
        case .gym:
            return "Gym"
        case .experience:
            return "Training experience"
        case .myGoal:
            return "My goal"
        case .shortStory:
            return "Short story"
        case .aboutMe:
            return "About me"
        case .achievements:
            return "Achievements"
        case .education:
            return "Education"
        case .other:
            return "Other"
        }
    }
}


class AboutMeCellViewModel {
    let type: AboutMeType
    let text: String
    
    init(type: AboutMeType, text: String) {
        self.type = type
        self.text = text
    }
}
