//
//  TrainerReviewsCoordinator.swift
//  fitapp
//
//  Created by  on 29.07.2023.
//

import UIKit

protocol TrainerReviewsCoordinatorTransitions: AnyObject {
    
}

class TrainerReviewsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case dismiss
        case review
    }
    
    weak var transitions: TrainerReviewsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private(set) weak var controller: TrainerReviewsViewController? = TrainerReviewsViewController.instantiate()
    
    private let type: ProfileType
    
    init(navigationController: UINavigationController?, type: ProfileType) {
        self.navigationController = navigationController
        self.type = type
        
        controller?.viewModel = TrainerReviewsViewModel(self, type: type)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension TrainerReviewsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .dismiss: dismiss()
        case .review: review()
        }
    }
    
    private func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func review() {
        let coordinator = ReviewTrainerCoordinator(presentedController: controller, id: type.id)
        coordinator.transitions = self
        coordinator.route(to: .`self`)
    }
}

// MARK: - ReviewTrainerCoordinatorTransitions

extension TrainerReviewsCoordinator: ReviewTrainerCoordinatorTransitions {
    func done() {
        controller?.viewModel.reload()
        
        let popup = FitappPopup.create(
            title: "Thanks!",
            description: "Your review will appear in the trainer's profile soon!"
        )
        
        controller?.present(popup, animated: true)
    }
}
