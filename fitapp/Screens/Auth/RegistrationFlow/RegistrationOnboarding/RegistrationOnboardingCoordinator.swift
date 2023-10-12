//
//  RegistrationOnboardingCoordinator.swift
//  fitapp
//

import UIKit

protocol RegistrationOnboardingCoordinatorTransitions: AnyObject {
    func onboardingDone()
    func login()
}

class RegistrationOnboardingCoordinator: DeinitAnnouncerType {
    
    enum Route {
        case `self`
        case onboardingWasShown
        case login
    }
    
    var transitions: RegistrationOnboardingCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: RegistrationOnboardingViewController? = RegistrationOnboardingViewController.instantiate()
    
   
    init(navigationController: UINavigationController?, user: UserData) {
        self.navigationController = navigationController
        controller?.viewModel = RegistrationOnboardingViewModel(self, user: user)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension RegistrationOnboardingCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .onboardingWasShown: onboardingDone()
        case .login: transitions?.login()
        }
    }
    
    private func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func onboardingDone() {
        navigationController?.popViewController(animated: true)
        transitions?.onboardingDone()
    }
    
}

