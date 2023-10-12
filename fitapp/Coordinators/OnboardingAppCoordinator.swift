//
//  OnboardingCoordinator.swift
//  fitapp
//

import UIKit

protocol OnboardingAppCoordinatorTransitions: AnyObject {
    func onboardingWasShown()
}

class OnboardingAppCoordinator {
    private var window: UIWindow
    
    var transitions: OnboardingAppCoordinatorTransitions?
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = root
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let coordinator = OnboardingCoordinator(navigationController: root)
        coordinator.transitions = self
        coordinator.route(to: .`self`)
    }
}

// MARK: - OnboardingAppCoordinatorTransitions -

extension OnboardingAppCoordinator: OnboardingCoordinatorTransitions {
    func onboardingDone() {
        transitions?.onboardingWasShown()
    }
    
}
