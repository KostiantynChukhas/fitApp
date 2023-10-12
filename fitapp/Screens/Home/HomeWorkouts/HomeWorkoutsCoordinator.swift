//
//  HomeWorkoutsCoordinator.swift
//  fitapp
//
//  Created by Sergey Pritula on 22.08.2023.
//


import UIKit

protocol HomeWorkoutsCoordinatorTransitions: AnyObject {
    
}

class HomeWorkoutsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
        case workout(model: WorkoutTableCellViewModel)
    }
    
    weak var transitions: HomeWorkoutsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: HomeWorkoutsViewController? = HomeWorkoutsViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = HomeWorkoutsViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension HomeWorkoutsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        case .workout(let model): workout(model: model)
        }
    }
    
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func workout(model: WorkoutTableCellViewModel) {
        let coordinator = WorkoutCoordinator(navigationController: navigationController)
        coordinator.route(to: .`self`)
    }
}
