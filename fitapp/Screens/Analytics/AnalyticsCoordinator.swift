//
//  AnalyticsCoordinator.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit

protocol AnalyticsCoordinatorTransitions: AnyObject {
    
}

class AnalyticsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case notifications
    }
    
    weak var transitions: AnalyticsCoordinatorTransitions?
    
    private lazy var analyticsStatsCoordinator = AnalyticsStatsCoordinator(navigationController: root)
    
    private lazy var analyticsMeasurementsCoordinator = AnalyticsMeasurementsCoordinator(navigationController: root)
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    private weak var tabBarController: HomeTabBarController?
    private weak var controller: AnalyticsViewController? = AnalyticsViewController.instantiate()
    
    init(tabBarController: HomeTabBarController?) {
        self.tabBarController = tabBarController
        setup()
        setupDeinitAnnouncer()
    }
    
    private func setup() {
        let analyticsStatsViewController: AnalyticsStatsViewController = AnalyticsStatsViewController.instantiate()
        analyticsStatsViewController.viewModel = AnalyticsStatsViewModel(analyticsStatsCoordinator)
        
        let analyticsMeasurementsViewController: AnalyticsMeasurementsViewController = AnalyticsMeasurementsViewController.instantiate()
        analyticsMeasurementsViewController.viewModel = AnalyticsMeasurementsViewModel(analyticsMeasurementsCoordinator)

        
        let analyticsSegmentViewModel = AnalyticsSegmentViewModel(dataSource: [
            analyticsStatsViewController, analyticsMeasurementsViewController
        ])
        
        controller?.viewModel = AnalyticsViewModel(
            self,
            analyticsSegmentViewModel: analyticsSegmentViewModel
        )
    }
    
}

// MARK: - Navigation

extension AnalyticsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .notifications: notifications()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        root.viewControllers = [controller]
        tabBarController?.addViewController(root, tabType: .analytics)
    }
    
    private func notifications() {
        let coordinator = NotificationsCoordinator(navigationController: root)
        coordinator.route(to: .`self`)
    }
    
}
