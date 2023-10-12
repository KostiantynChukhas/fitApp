//
//  LoginPreviewCoordinator.swift
//  StartProjectsMVVM + C
//

import UIKit

protocol LoginPreviewCoordinatorTransitions: AnyObject {
    func showRegistrationOnboarding(user: UserData)
    func showMain()
}

class LoginPreviewCoordinator: DeinitAnnouncerType {
    
    private var window: UIWindow
    
    enum Route {
        case `self`
        case login
        case registration
    }
    
    weak var transitions: LoginPreviewCoordinatorTransitions?
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    private weak var controller: LoginPreviewViewController? = LoginPreviewViewController.instantiate()
    
    private var loginCoordinator: LoginCoordinator?
    private var registrationCoordinator: RegistrationCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = root
        self.window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.6,
                          options: .transitionFlipFromRight,
                          animations: nil,
                          completion: nil)
        
        controller?.viewModel = LoginPreviewViewModel(self)
        
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation -

extension LoginPreviewCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .login: login()
        case .registration: registration()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        root.viewControllers = [controller]
    }
    
    private func login() {
        loginCoordinator = LoginCoordinator(navigationController: root)
        loginCoordinator?.transitions = self
        loginCoordinator?.route(to: .`self`)
    }
    
    private func registration() {
        registrationCoordinator = RegistrationCoordinator(navigationController: root)
        registrationCoordinator?.transitions = self
        registrationCoordinator?.route(to: .`self`)
    }
    
}

extension LoginPreviewCoordinator: LoginCoordinatorTransitions, RegistrationCoordinatorTransitions {
    func showMain() {
        transitions?.showMain()
    }
    
    func showRegistrationOnboarding(user: UserData) {
        transitions?.showRegistrationOnboarding(user: user)
    }
    
    func showLogin() {
        if let index = root.viewControllers.firstIndex(where: { $0 is LoginViewController }) {
            root.popToViewController(root.viewControllers[index], animated: true)
        } else {
            login()
        }
    }
    
    func showRegistration() {
        if let index = root.viewControllers.firstIndex(where: { $0 is RegistrationViewController }) {
            root.popToViewController(root.viewControllers[index], animated: true)
        } else {
            registration()
        }
    }
}
