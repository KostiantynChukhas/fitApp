//
//  ForgotPasswordCoordinator.swift
//  fitapp
//

import UIKit

class ForgotPasswordCoordinator: DeinitAnnouncerType {
    
    enum Route {
        case `self`
        case back
        case done
    }
    
    private weak var navigationController: UINavigationController?
    private weak var controller: ForgotPasswordViewController? = ForgotPasswordViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = ForgotPasswordViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation

extension ForgotPasswordCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        case .done: done()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func done() {
        let coordinator = ForgotPasswordDonePopupCoordinator(presentedController: controller)
        coordinator.route(to: .`self`)
    }
}

