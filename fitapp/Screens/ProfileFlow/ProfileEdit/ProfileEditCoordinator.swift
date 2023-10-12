//
//  ProfileEditCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol ProfileEditCoordinatorTransitions: AnyObject {
    func getUserData(model: UserData?)
}

class ProfileEditCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
        case backWithModel(model: UserData?)
    }
    
    weak var transitions: ProfileEditCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: ProfileEditViewController? = .instantiate()
    
    init(navigationController: UINavigationController?, avatar: String) {
        self.navigationController = navigationController
        controller?.viewModel = ProfileEditViewModel(self, avatar: avatar)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension ProfileEditCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        case .backWithModel(let model): backWithModel(model: model)
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        navigationController?.present(controller, animated: true)
    }
    
    private func back() {
        navigationController?.dismiss(animated: true)
    }
    
    private func backWithModel(model: UserData?) {
        transitions?.getUserData(model: model)
        navigationController?.dismiss(animated: true)
    }
    
}
