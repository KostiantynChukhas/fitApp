//
//  NotificationsCoordinator.swift
//  fitapp
//

//

import UIKit

protocol NotificationsCoordinatorTransitions: AnyObject {
    
}

class NotificationsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: NotificationsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private var controller: NotificationsViewController = NotificationsViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller.viewModel = NotificationsViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension NotificationsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        }
    }
    
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        navigationController?.pushViewController(controller, animated: true)
    }
}
