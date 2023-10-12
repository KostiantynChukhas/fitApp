//
//  ProfileFeedsCoordinator.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit

protocol ProfileFeedsCoordinatorTransitions: AnyObject {
    
}

class ProfileFeedsCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case share(model: CommunityViewData)
        case showDetail(model: CommunityCellViewModel)
    }
    
    weak var transitions: ProfileFeedsCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private(set) weak var controller: ProfileFeedsViewController? = .instantiate()
    
    init(navigationController: UINavigationController?, type: ProfileType) {
        self.navigationController = navigationController
        controller?.viewModel = ProfileFeedsViewModel(self, type: type)
        setupDeinitAnnouncer()
    }
    
}

// MARK: - Navigation

extension ProfileFeedsCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .share(let model): share(model: model)
        case .showDetail(let model): showDetail(model: model)
        }
    }
    
    private func start() { }
    
    private func share(model: CommunityViewData) {
        let message = "Share with your friends"
        let objectsToShare = [message]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        self.controller?.present(activityVC, animated: true)
    }
    
    private func showDetail(model: CommunityCellViewModel) {
        let coordinator = CommunityDetailCoordinator(
            navigationController: navigationController,
            model: .init(model: model.model)
        )
        coordinator.route(to: .`self`)
    }
}
