//
//  ForgotPasswordDonePopupCoordinator.swift
//  fitapp
//
//   on 06.05.2023.
//

import UIKit

class ForgotPasswordDonePopupCoordinator: DeinitAnnouncerType {
    
    enum Route {
        case `self`
        case back
    }
    
    private weak var presentedController: UIViewController?
    private weak var controller: ForgotPasswordDoneViewController? = ForgotPasswordDoneViewController.instantiate()
    
    init(presentedController: UIViewController?) {
        self.presentedController = presentedController
        controller?.viewModel = ForgotPasswordDoneViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension ForgotPasswordDonePopupCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        presentedController?.present(controller, animated: true)
    }
    
    private func back() {
        controller?.dismiss(animated: true)
    }
}

