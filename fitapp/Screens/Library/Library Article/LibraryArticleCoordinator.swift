//
//  LibraryArticleArticleCoordinator.swift
//  fitapp
//
//  on 13.05.2023.
//

import UIKit

protocol LibraryArticleCoordinatorTransitions: AnyObject {
}

class LibraryArticleCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: LibraryArticleCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: LibraryArticleViewController? = LibraryArticleViewController.instantiate()
    
    init(navigationController: UINavigationController?, model: LibraryData) {
        self.navigationController = navigationController
        controller?.viewModel = LibraryArticleViewModel(self, model: model)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation -

extension LibraryArticleCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        }
    }
    
    private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
}
