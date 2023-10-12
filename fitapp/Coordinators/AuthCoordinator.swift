//
//  AuthCoordinator.swift
//  fitapp
//

import UIKit

protocol AuthCoordinatorTransitions: AnyObject {
    func showMain()
}

class AuthCoordinator {
    private var window: UIWindow
    
    weak var transitions: AuthCoordinatorTransitions?
    
    private var coordinator: LoginPreviewCoordinator?
    private var registrationFlowCoordnator: RegistrationFlowCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        coordinator = LoginPreviewCoordinator(window: window)
        coordinator?.transitions = self
        coordinator?.route(to: .`self`)
    }
    
    private func startRegistrationOnboarding(user: UserData) {
        registrationFlowCoordnator = RegistrationFlowCoordinator(window: window)
        registrationFlowCoordnator?.transitions = self
        registrationFlowCoordnator?.start(with: user)
    }
}

// MARK: - LoginCoordinatorTransitions -

extension AuthCoordinator: LoginPreviewCoordinatorTransitions {
    func showMain() {
        transitions?.showMain()
    }
    
    func showRegistrationOnboarding(user: UserData) {
        startRegistrationOnboarding(user: user)
    }
}

extension AuthCoordinator: RegistrationFlowCoordinatorTransitions {
    func login() {
        start()
    }
    
    func onboardingWasShown() {
        transitions?.showMain()
    }
}
