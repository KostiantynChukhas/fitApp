//
//  LoginCoordinator.swift
//  StartProjectsMVVM + C
//

import UIKit

protocol LoginCoordinatorTransitions: AnyObject {
    func showRegistrationOnboarding(user: UserData)
    func showMain()
    func showRegistration()
}

class LoginCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case preview
        case registration
        case forgot
        case onboardingRegistration(user: UserData)
        case home
    }
    
    weak var transitions: LoginCoordinatorTransitions?
    var registrationCoordinator: RegistrationCoordinator?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: LoginViewController? = LoginViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = LoginViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation -

extension LoginCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .preview: preview()
        case .registration: registration()
        case .forgot: forgot()
        case .onboardingRegistration(let user):  startRegistrationOnboarding(user: user)
        case .home: home()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func preview() {
        navigationController?.popViewController(animated: true)
    }
    
    private func registration() {
        transitions?.showRegistration()
    }
    
    private func startRegistrationOnboarding(user: UserData) {
        transitions?.showRegistrationOnboarding(user: user)
    }
    
    private func home() {
        transitions?.showMain()
    }
    
    private func forgot() {
        let coordinator = ForgotPasswordCoordinator(navigationController: navigationController)
        coordinator.route(to: .`self`)
    }
}
