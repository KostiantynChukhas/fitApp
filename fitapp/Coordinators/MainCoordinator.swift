//
//  MainCoordinator.swift
//  fitapp
//
// on 10.05.2023.
//

import UIKit

protocol MainCoordinatorTransitions: AnyObject {
    func didLogOut()
}

class MainCoordinator {
    private var window: UIWindow
    
    weak var transitions: MainCoordinatorTransitions?
    private var coordinator: HomeTabBarCoordinator?
    
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
        coordinator = HomeTabBarCoordinator(
            injections: .init(
                window: window,
                navigationController: root
            )
        )
        coordinator?.transitions = self
        coordinator?.start()
    }
}

// MARK: - LoginCoordinatorTransitions -


extension MainCoordinator: HomeCoordinatorTransitions {
    func didLogOut() {
        transitions?.didLogOut()
    }
}

extension MainCoordinator: HomeTabBarCoordinatorTransitions {
    func logout() {
        transitions?.didLogOut()
    }
}
