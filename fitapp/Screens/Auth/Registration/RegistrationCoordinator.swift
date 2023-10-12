//
//  RegistrationCoordinator.swift
//  StartProjectsMVVM + C
//

import UIKit

protocol RegistrationCoordinatorTransitions: AnyObject {
    func showRegistrationOnboarding(user: UserData)
    func showLogin()
    func showMain()
}

class RegistrationCoordinator: DeinitAnnouncerType {
    
    enum Route {
        case `self`
        case home
        case login
        case forgot
        case onboardingRegistration(user: UserData)
    }
    
    weak var transitions: RegistrationCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: RegistrationViewController? = RegistrationViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = RegistrationViewModel(self)
        setupDeinitAnnouncer()
    }
}

extension RegistrationCoordinator {
    
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .home: home()
        case .login: login()
        case .forgot: forgot()
        case .onboardingRegistration(let user): startRegistrationOnboarding(user: user)
        }
    }
    
    private func login() {
        transitions?.showLogin()
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func forgot() {
        let coordinator = ForgotPasswordCoordinator(navigationController: navigationController)
        coordinator.route(to: .`self`)
    }
    
    private func startRegistrationOnboarding(user: UserData) {
        transitions?.showRegistrationOnboarding(user: user)
    }
    
    private func home() {
        transitions?.showMain()
    }
    
}
// MARK: - Transitions -

extension RegistrationCoordinator {
}
