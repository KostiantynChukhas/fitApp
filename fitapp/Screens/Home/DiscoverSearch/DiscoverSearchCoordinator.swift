//
//  DiscoverSearchCoordinator.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 05.07.2023.
//

import UIKit
protocol DiscoverSearchCoordinatorTransitions: AnyObject {
}

class DiscoverSearchCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
    }
    
    weak var transitions: DiscoverSearchCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: DiscoverSearchViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = DiscoverSearchViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation

extension DiscoverSearchCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()

        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
}

