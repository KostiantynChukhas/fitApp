//
//  HomeTrainersCoordinator.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit

protocol HomeTrainersCoordinatorTransitions: AnyObject {
    
}

class HomeTrainersCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case trainer(data: TrainerData)
    }
    
    weak var transitions: HomeTrainersCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: HomeTrainersViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = HomeTrainersViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension HomeTrainersCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .trainer(let trainer): trainerRoute(trainer: trainer)
        }
    }
    
    private func start() {}
    
    private func trainerRoute(trainer: TrainerData) {
        guard let navigationController = navigationController else { return }
        
        let coordinator = ProfileCoordinator(
            config: .navigation(controller: navigationController),
            type: .trainer(model: trainer)
        )
        coordinator.route(to: .`self`)
    }
    
}
