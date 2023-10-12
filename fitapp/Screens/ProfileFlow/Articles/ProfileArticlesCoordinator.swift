//
//  ProfileArticlesCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol ProfileArticlesCoordinatorTransitions: AnyObject {
    
}

class ProfileArticlesCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case article(model: LibraryData)
    }
    
    weak var transitions: ProfileArticlesCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private(set) weak var controller: ProfileArticlesViewController? = .instantiate()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = ProfileArticlesViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension ProfileArticlesCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .article(let model): article(model: model)
        }
    }
    
    private func start() {
        
    }
    
    private func article(model: LibraryData) {
        guard let navigationController = navigationController else { return }
        let coordinator = LibraryArticleCoordinator(navigationController: navigationController, model: model)
        coordinator.route(to: .`self`)
    }
    
}
