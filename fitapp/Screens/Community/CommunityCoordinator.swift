//
//  CommunityCoordinator.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit

protocol CommunityCoordinatorTransitions: AnyObject {
    
}

class CommunityCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case addPost
        case showDetail(model: CommunityCellViewModel)
        case share(model: CommunityViewData)
    }
    
    weak var transitions: CommunityCoordinatorTransitions?
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    private weak var tabBarController: HomeTabBarController?
    private weak var controller: CommunityViewController? = CommunityViewController.instantiate()
    
    init(tabBarController: HomeTabBarController?) {
        self.tabBarController = tabBarController
        controller?.viewModel = CommunityViewModel(self)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension CommunityCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .addPost: addPost()
        case .showDetail(let model): showDetail(model: model)
        case .share(let model): share(model: model)
        }
    }
    
    private func start() {
        guard let controller = controller else { return }
        root.viewControllers = [controller]
        tabBarController?.addViewController(root, tabType: .community)
    }
    
    private func addPost() {
        let coordinator = CommunityAddPostCoordinator(navigationController: root)
        coordinator.route(to: .`self`)
    }
    
    private func showDetail(model: CommunityCellViewModel) {
        let coordinator = CommunityDetailCoordinator(navigationController: root, model: .init(model: model.model))
        coordinator.route(to: .`self`)
    }
    
    private func share(model: CommunityViewData) {
        let message = "Share with your friends"
        let objectsToShare = [message]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        self.controller?.present(activityVC, animated: true)
    }
}
