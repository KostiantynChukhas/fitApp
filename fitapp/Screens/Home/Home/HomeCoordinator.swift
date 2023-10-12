//
//  HomeCoordinator.swift
//  fitapp
//
// on 09.05.2023.
//

import UIKit

protocol HomeCoordinatorTransitions: AnyObject {
    func didLogOut()
}

class HomeCoordinator: DeinitAnnouncerType {
    
    enum Route {
        case `self`
        case logOut
        case notifications
    }
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    private weak var tabBarController: HomeTabBarController?
    weak var transitions: HomeCoordinatorTransitions?
    
    private lazy var homeDiscoverCoordinator = HomeDiscoverCoordinator(navigationController: root)
    
    private lazy var homeTrainersCoordinator = HomeTrainersCoordinator(navigationController: root)
    
    private lazy var homeMyPlanCoordinator = HomeMyPlanCoordinator(navigationController: root)
    
    private weak var controller: HomeViewController? = .instantiate()
    
    init(tabBarController: HomeTabBarController?) {
        self.tabBarController = tabBarController
        setup()
        setupDeinitAnnouncer()
    }
    
    private func setup() {
        let homeDiscoverViewController: HomeDiscoverViewController = HomeDiscoverViewController.instantiate()
        homeDiscoverViewController.viewModel = HomeDiscoverViewModel(homeDiscoverCoordinator)
        
        let homeTrainersViewController: HomeTrainersViewController = HomeTrainersViewController.instantiate()
        homeTrainersViewController.viewModel = HomeTrainersViewModel(homeTrainersCoordinator)
        
        let homeMyPlanViewController: HomeMyPlanViewController = HomeMyPlanViewController.instantiate()
        homeMyPlanViewController.viewModel = HomeMyPlanViewModel(homeMyPlanCoordinator)

        
        let homeSegmentViewModel = HomeSegmentViewModel(dataSource: [
            homeDiscoverViewController, homeTrainersViewController, homeMyPlanViewController
        ])
        
        controller?.viewModel = HomeViewModel(
            self,
            homeSegmentViewModel: homeSegmentViewModel
        )
        
    }
}

// MARK: - Navigation -

extension HomeCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .logOut: transitions?.didLogOut()
        case .notifications: notifications()
        }
    }
    private func start() {
        guard let controller = controller else { return }
        root.viewControllers = [controller]
        tabBarController?.addViewController(root, tabType: .home)
    }
    
    private func notifications() {
        let coordinator = NotificationsCoordinator(navigationController: root)
        coordinator.route(to: .`self`)
    }
}

