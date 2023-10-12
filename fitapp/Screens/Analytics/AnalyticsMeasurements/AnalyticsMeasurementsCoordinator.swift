//
//  AnalyticsMeasurementsCoordinator.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import UIKit

protocol AnalyticsMeasurementsCoordinatorTransitions: AnyObject {
    
}

class AnalyticsMeasurementsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
    }
    
    weak var transitions: AnalyticsMeasurementsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: AnalyticsMeasurementsViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = AnalyticsMeasurementsViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension AnalyticsMeasurementsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        }
    }
    
    private func start() {
        
    }
    
}
