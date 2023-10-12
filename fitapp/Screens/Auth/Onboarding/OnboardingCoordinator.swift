//
//  OnboardingCoordinator.swift
//
//

import UIKit

protocol OnboardingCoordinatorTransitions: AnyObject {
    func onboardingDone()
}

class OnboardingCoordinator: DeinitAnnouncerType {
    
    enum Route {
        case `self`
        case onboardingWasShown
    }
    
    weak var transitions: OnboardingCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: OnboardingViewController? = OnboardingViewController.instantiate()
    
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = OnboardingViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation -

extension OnboardingCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .onboardingWasShown: onboardingDone()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func onboardingDone() {
        transitions?.onboardingDone()
    }
    
}

