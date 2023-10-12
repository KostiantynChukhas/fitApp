//
//  ReviewTrainerCoordinator.swift
//  fitapp
//
//  Created by  on 23.07.2023.
//

import UIKit

protocol ReviewTrainerCoordinatorTransitions: AnyObject {
    func done()
}

class ReviewTrainerCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case dismiss
        case reviewDone
    }
    
    weak var transitions: ReviewTrainerCoordinatorTransitions?
    
    private weak var presentedController: UIViewController?
    private weak var controller: ReviewTrainerViewController? = ReviewTrainerViewController.instantiate()
    
    init(presentedController: UIViewController?, id: String) {
        self.presentedController = presentedController
        controller?.viewModel = ReviewTrainerViewModel(self, id: id)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension ReviewTrainerCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .dismiss: dismiss()
        case .reviewDone: reviewDone()
        }
    }
    
    private func dismiss() {
        presentedController?.dismiss(animated: true)
    }
    
    private func start() {
        if let controller = controller {
            presentedController?.presentPanModal(controller)
        }
    }
    
    private func reviewDone() {
        presentedController?.dismiss(animated: true, completion: { [weak self] in
            self?.transitions?.done()
        })
    }
}
