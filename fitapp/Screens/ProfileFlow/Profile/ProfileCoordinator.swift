//
//  ProfileCoordinator.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit

protocol ProfileCoordinatorTransitions: AnyObject {
    func logout()
}

enum ProfileCoordinatorConfig {
    case tabBar(controller: HomeTabBarController)
    case navigation(controller: UINavigationController)
}

class ProfileCoordinator: DeinitAnnouncerType {
    
    enum Route {
        case `self`
        case editProfile(avatar: String)
        case settings
        case back
        case messages
    }
    
    weak var transitions: ProfileCoordinatorTransitions?
    
    private lazy var profilePhotosCoordinator = ProfilePhotosCoordinator(navigationController: root, type: type)
    
    private lazy var aboutMeCoordinator = AboutMeCoordinator(navigationController: root, type: type)
    
    private lazy var feedCoordinator = ProfileFeedsCoordinator(navigationController: root, type: type)
    
    private lazy var articlesCoordinator = ProfileArticlesCoordinator(navigationController: root)
    
    private lazy var reviewsCoordinator = TrainerReviewsCoordinator(navigationController: root, type: type)
    
    private lazy var userControllers = [
        profilePhotosCoordinator.controller,
        aboutMeCoordinator.controller,
        feedCoordinator.controller
    ]
    
    private lazy var ownProfileControllers = [
        profilePhotosCoordinator.controller,
        aboutMeCoordinator.controller,
        feedCoordinator.controller,
        articlesCoordinator.controller
    ]
    
    private lazy var trainerController = [
        profilePhotosCoordinator.controller, aboutMeCoordinator.controller, reviewsCoordinator.controller
    ]
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    private weak var controller: ProfileViewController? = .instantiate()
    private var config: ProfileCoordinatorConfig
    private var type: ProfileType
    
    init(config: ProfileCoordinatorConfig, type: ProfileType) {
        self.config = config
        self.type = type
        
        self.setup(type: type)
        
        setupDeinitAnnouncer()
    }
    
    private func setup(type: ProfileType) {
        var controllers: [UIViewController] = []
        var items: [TopSegmentCollectionViewModel] = []
        
        switch type {
        case .ownProfile:
            controllers = ownProfileControllers.compactMap { $0 }
            items = SegmentItemType.ownProfileItems.map { .init(type: $0, isActive: $0 == .photos) }
        case .userProfile:
            controllers = userControllers.compactMap { $0 }
            items = SegmentItemType.userProfileItems.map { .init(type: $0, isActive: $0 == .photos) }
        case .trainer:
            controllers = trainerController.compactMap { $0 }
            items = SegmentItemType.trainerItems.map { .init(type: $0, isActive: $0 == .photos) }
        }
        
        let mainSegmentViewModel = MainSegmentViewModel(dataSource: controllers)
        let topSegmentViewModel = TopSegmentViewModel(dataSource: items)
        
        controller?.viewModel = ProfileViewModel(
            self,
            topSegmentViewModel: topSegmentViewModel,
            mainSegmentViewModel: mainSegmentViewModel,
            type: type
        )
    }
    
}

// MARK: - Navigation

extension ProfileCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .editProfile(let avatar): editProfile(avatar: avatar)
        case .settings: settings()
        case .back: back()
        case .messages:  messages()
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        
        switch config {
        case .tabBar(let tabBarController):
            root.viewControllers = [controller]
            tabBarController.addViewController(root, tabType: .profile)
        case .navigation(let navigationController):
            navigationController.pushViewController(controller, animated: true)
        }
    }
    
    private func editProfile(avatar: String) {
        let coordinator = ProfileEditCoordinator(navigationController: root, avatar: avatar)
        coordinator.transitions = self
        coordinator.route(to: .`self`)
    }
    
    private func settings() {
        let coordinator = SettingsCoordinator(navigationController: root)
        coordinator.transitions = self
        coordinator.route(to: .`self`)
    }
    
    private func back() {
        switch config {
        case .navigation(let navigationController):
            navigationController.popViewController(animated: true)
        case .tabBar:
            break
        }
    }
    
    private func messages() {
        
    }
    
}

// MARK: - SettingsCoordinatorTransitions
 
extension ProfileCoordinator: SettingsCoordinatorTransitions {
    func logout() {
        transitions?.logout()
    }
}

// MARK: - ProfileEditCoordinatorTransitions

extension ProfileCoordinator: ProfileEditCoordinatorTransitions {
    func getUserData(model: UserData?) {
        guard let data = model else { return }
        controller?.viewModel.reload(userData: data)
    }
    
}
