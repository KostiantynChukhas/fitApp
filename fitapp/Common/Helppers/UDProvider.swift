//
//  UDProvider.swift
//  fitapp
//

import Foundation
class UDProvider {
    
    struct Keys {
        static let onboardingShown = "onboardingShown"
        static let registrationOnboarding = "registrationOnboarding"
    }
    
    static let userDefaults = UserDefaults.standard
    
    static func sync() {
        userDefaults.synchronize()
    }
    
    static var onboardingWasShown: Bool {
        set {
            userDefaults.set(newValue, forKey: Keys.onboardingShown)
            sync()
        }
        get { return userDefaults.bool(forKey: Keys.onboardingShown) }
    }
    
    static var registrationOnboardingWasShown: Bool {
        set {
            userDefaults.set(newValue, forKey: Keys.registrationOnboarding)
            sync()
        }
        get { return userDefaults.bool(forKey: Keys.registrationOnboarding) }
    }
}
