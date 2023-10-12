//
//  DiscoverCategoryCoordinator.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 05.07.2023.
//

import UIKit

protocol DiscoverCategoryCoordinatorTransitions: AnyObject {
}

class DiscoverCategoryCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: DiscoverCategoryCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private var controller: DiscoverCategoryViewController = DiscoverCategoryViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller.viewModel = DiscoverCategoryViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension DiscoverCategoryCoordinator {
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
