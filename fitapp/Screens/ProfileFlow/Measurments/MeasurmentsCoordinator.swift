//
//  MeasurmentsCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol MeasurmentsCoordinatorTransitions: AnyObject {
    
}

class MeasurmentsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
    }
    
    weak var transitions: MeasurmentsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: MeasurmentsViewController? = MeasurmentsViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = MeasurmentsViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension MeasurmentsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
