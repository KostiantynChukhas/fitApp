//
//  HomeDiscoverCoordinator.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit

protocol HomeDiscoverCoordinatorTransitions: AnyObject {
    
}

class HomeDiscoverCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case categories
        case searchDiscover
    }
    
    weak var transitions: HomeDiscoverCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: HomeDiscoverViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = HomeDiscoverViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension HomeDiscoverCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .categories: categories()
        case .searchDiscover: searchDiscover()

        }
    }
    
    private func start() {}
    
    private func categories() {
        let coordinator = DiscoverCategoryCoordinator(navigationController: navigationController)
        coordinator.route(to: .`self`)
    }
    
    private func searchDiscover() {
        let coordinator = DiscoverSearchCoordinator(navigationController: navigationController)
        coordinator.route(to: .`self`)
    }
    
}

