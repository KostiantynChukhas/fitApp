//
//  AboutMeCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol AboutMeCoordinatorTransitions: AnyObject {
    
}

class AboutMeCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
    }
    
    weak var transitions: AboutMeCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private(set) weak var controller: AboutMeViewController? = .instantiate()
    
    init(navigationController: UINavigationController?, type: ProfileType) {
        self.navigationController = navigationController
        controller?.viewModel = AboutMeViewModel(self, type: type)
        
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension AboutMeCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        }
    }
    
    private func start() {
        
    }
    
}
