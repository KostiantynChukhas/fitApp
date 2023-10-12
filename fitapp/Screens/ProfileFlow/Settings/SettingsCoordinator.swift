//
//  SettingsCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol SettingsCoordinatorTransitions: AnyObject {
    func logout()
}

class SettingsCoordinator: DeinitAnnouncerType, DeleteAccountPopupCoordinatorTransitions {
    enum Route {
        case `self`
        case back
        case deleteAccount
        case setUnits
        case logout
    }
    
    weak var transitions: SettingsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: SettingsViewController? = .instantiate()
    
    private var unitCoordinator: UnitSettingsCoordinator?
    private var deleteCoordinator: DeleteAccountPopupCoordinator?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = SettingsViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension SettingsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: navigationController?.popViewController(animated: true)
        case .setUnits: setUnits()
        case .deleteAccount: deleteAccount()
        case .logout: logout()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setUnits() {
        guard let navigationController = navigationController else { return }
        let coordinator = UnitSettingsCoordinator(navigationController: navigationController)
        coordinator.route(to: .`self`)
    }
    
    private func deleteAccount() {
        guard let navigationController = navigationController else { return }
        deleteCoordinator = DeleteAccountPopupCoordinator(navigationController: navigationController)
        deleteCoordinator?.transitions = self
        deleteCoordinator?.route(to: .`self`)
    }
    
    internal func logout() {
        self.transitions?.logout()
    }
}
