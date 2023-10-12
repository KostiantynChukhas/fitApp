//
//  HomeMyPlanCoordinator.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit

protocol HomeMyPlanCoordinatorTransitions: AnyObject {
    
}

class HomeMyPlanCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case moreWorkouts
    }
    
    weak var transitions: HomeMyPlanCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: HomeMyPlanViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = HomeMyPlanViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension HomeMyPlanCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .moreWorkouts: moreWorkouts()
        }
    }
    
    private func start() { }
    
    private func moreWorkouts() {
        let coordinator = HomeWorkoutsCoordinator(navigationController: navigationController)
        coordinator.route(to: .`self`)
    }
    
}
