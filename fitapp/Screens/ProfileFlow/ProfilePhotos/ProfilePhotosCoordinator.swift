//
//  ProfilePhotosCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol ProfilePhotosCoordinatorTransitions: AnyObject {
    
}

class ProfilePhotosCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
    }
    
    weak var transitions: ProfilePhotosCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private(set) weak var controller: ProfilePhotosViewController? = .instantiate()
    
    init(navigationController: UINavigationController?, type: ProfileType) {
        self.navigationController = navigationController
        controller?.viewModel = ProfilePhotosViewModel(self, type: type)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension ProfilePhotosCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        }
    }
    
    private func start() {
        
    }
    
}
