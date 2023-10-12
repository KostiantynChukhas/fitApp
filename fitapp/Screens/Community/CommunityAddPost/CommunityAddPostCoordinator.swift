//
//  CommunityAddPostCoordinator.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit

protocol CommunityAddPostCoordinatorTransitions: AnyObject {
}

class CommunityAddPostCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: CommunityAddPostCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private var controller: CommunityAddPostViewController = CommunityAddPostViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller.viewModel = CommunityAddPostViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation
extension CommunityAddPostCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        }
    }
    
    private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        navigationController?.pushViewController(controller, animated: true)
    }
}
