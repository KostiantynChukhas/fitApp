//
//  LibraryCoordinator.swift
//  fitapp
//
//  on 07.05.2023.
//

import UIKit

protocol LibraryCoordinatorTransitions: AnyObject {
}

class LibraryCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case categories
        case article(model: LibraryData)
        case notifications
    }
    
    weak var transitions: LibraryCoordinatorTransitions?
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    private weak var tabBarController: HomeTabBarController?
    private weak var controller: LibraryViewController? = LibraryViewController.instantiate()
    
    init(tabBarController: HomeTabBarController?) {
        self.tabBarController = tabBarController
        controller?.viewModel = LibraryViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension LibraryCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .categories: categories()
        case .article(let model): article(model: model)
        case .notifications: notifications()
        }
    }
    
    private func categories() {
        let coordinator = LibraryCategoryCoordinator(navigationController: root)
        coordinator.transitions = self
        coordinator.route(to: .`self`)
    }
    
    private func start() {
        guard let controller = controller else { return }
        root.viewControllers = [controller]
        tabBarController?.addViewController(root, tabType: .library)
    }
    
    private func article(model: LibraryData) {
        let coordinator = LibraryArticleCoordinator(navigationController: root, model: model)
        coordinator.route(to: .`self`)
    }
    
    private func notifications() {
        let coordinator = NotificationsCoordinator(navigationController: root)
        coordinator.route(to: .`self`)
    }
}

extension LibraryCoordinator: LibraryCategoryCoordinatorTransitions {
}
