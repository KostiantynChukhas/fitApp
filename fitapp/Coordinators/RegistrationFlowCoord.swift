//
//  RegistrationFlowCoord.swift
//  fitapp
//

import Foundation
import UIKit


protocol RegistrationFlowCoordinatorTransitions: AnyObject {
    func onboardingWasShown()
    func login()
}

class RegistrationFlowCoordinator {
    private var window: UIWindow
    
    weak var transitions: RegistrationFlowCoordinatorTransitions?
    private var currentStage = 0
    
    private var coordinator: RegistrationOnboardingCoordinator?
    
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
    
    func start(with user: UserData) {
        coordinator = RegistrationOnboardingCoordinator(navigationController: root, user: user)
        coordinator?.transitions = self
        coordinator?.route(to: .`self`)
    }
}

extension RegistrationFlowCoordinator: RegistrationOnboardingCoordinatorTransitions {
    func onboardingDone() {
        transitions?.onboardingWasShown()
    }
    
    func login() {
        transitions?.login()
    }
}



