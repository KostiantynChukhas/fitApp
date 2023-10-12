//
//  AnalyticsStatsCoordinator.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import UIKit

protocol AnalyticsStatsCoordinatorTransitions: AnyObject {
    
}

class AnalyticsStatsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
    }
    
    weak var transitions: AnalyticsStatsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: AnalyticsStatsViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = AnalyticsStatsViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension AnalyticsStatsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        }
    }
    
    private func start() {
        
    }
    
}
