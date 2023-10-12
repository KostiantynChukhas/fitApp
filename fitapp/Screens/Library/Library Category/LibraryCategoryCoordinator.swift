//
//  LibraryCategoryCoordinator.swift
//  fitapp
//
//  on 11.05.2023.
//

import UIKit

protocol LibraryCategoryCoordinatorTransitions: AnyObject {
}

class LibraryCategoryCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: LibraryCategoryCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private var controller: LibraryCategoryViewController = LibraryCategoryViewController.instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller.viewModel = LibraryCategoryViewModel(self)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension LibraryCategoryCoordinator {
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
        navigationController?.pushViewController(controller, animated: true)
    }
}
