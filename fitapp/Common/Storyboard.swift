//
//  Storyboard.swift
//  fitapp
//

import Foundation
import UIKit

enum Storyboard {
    static let registration = storyboard(name: "Registration")
    static let login = storyboard(name: "Login")
    static let loginPreview = storyboard(name: "LoginPreview")
    static let forgot = storyboard(name: "ForgotPassword")
    static let onboarding = storyboard(name: "Onboarding")
    static let registrationFlow = storyboard(name: "RegistrationFlow")
    static let library = storyboard(name: "Library")
}

private func storyboard(name: String, bundle: Bundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: bundle)
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

// MARK: - UIStoryboard + instantiate -

extension UIStoryboard {
    func instantiate<T: StoryboardIdentifiable>() -> T {
        guard let controller = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Controller is nil with the identifier: \(T.storyboardIdentifier)")
        }
        return controller
    }
}

// MARK: - StoryboardIdentifiable -

extension UIViewController: StoryboardIdentifiable {}


// MARK: - StoryboardIdentifiable where Self: UIViewController -

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}
