//
//  WorkoutCoordinator.swift
//  fitapp
//
//  Created by Sergey Pritula on 22.08.2023.
//

import UIKit

protocol WorkoutCoordinatorTransitions: AnyObject {
    
}

class WorkoutCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: WorkoutCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: WorkoutViewController? = WorkoutViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = WorkoutViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension WorkoutCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        }
    }
    
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
}
