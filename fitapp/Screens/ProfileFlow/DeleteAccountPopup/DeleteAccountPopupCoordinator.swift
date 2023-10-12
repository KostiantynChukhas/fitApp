//
//  DeleteAccountPopupCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol DeleteAccountPopupCoordinatorTransitions: AnyObject {
    func logout()
}

class DeleteAccountPopupCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
        case logout
    }
    
    weak var transitions: DeleteAccountPopupCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: DeleteAccountPopup? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = DeleteAccountPopupViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension DeleteAccountPopupCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: controller?.dismiss(animated: true)
        case .logout: logout()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.present(controller, animated: true)
    }
    
    func logout() {
        transitions?.logout()
    }
    
}
