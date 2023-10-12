//
//  UnitSettingsCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol UnitSettingsCoordinatorTransitions: AnyObject {
    
}

class UnitSettingsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: UnitSettingsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: UnitSettingsViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = UnitSettingsViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension UnitSettingsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: navigationController?.popViewController(animated: true)
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
