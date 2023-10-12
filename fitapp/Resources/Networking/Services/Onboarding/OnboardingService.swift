//
//  OnboardingService.swift
//  fitapp
//
//   on 04.05.2023.
//

import Foundation

class OnboardingService {
    struct Constants {
        static let wasShownKey = "onboarding_was_shown"
    }
    
    static var shared: OnboardingService = {
        let instance = OnboardingService()
        return instance
    }()
    
    var wasShown: Bool {
        UserDefaults.standard.bool(forKey: Constants.wasShownKey)
    }
    
    func setShown() {
        UserDefaults.standard.set(true, forKey: Constants.wasShownKey)
    }
}
