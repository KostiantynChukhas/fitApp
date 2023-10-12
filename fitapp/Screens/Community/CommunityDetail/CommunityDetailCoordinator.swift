//
//  CommunityDetailCoordinator.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit

protocol CommunityDetailCoordinatorTransitions: AnyObject {
}

class CommunityDetailCoordinator: DeinitAnnouncerType {
    enum Route {
        case `self`
        case back
        case share(model: CommunityViewData)
    }
    
    weak var transitions: CommunityDetailCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private var controller: CommunityDetailViewController = CommunityDetailViewController.instantiate()
    
    init(navigationController: UINavigationController?, model: CommunityCellViewModel) {
        self.navigationController = navigationController
        controller.viewModel = CommunityDetailViewModel(self, model: model)
        setupDeinitAnnouncer()
    }
}

// MARK: - Navigation
extension CommunityDetailCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        case .share(let model): share(model: model)
        }
    }
    
    private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        navigationController?.pushViewController(controller, animated: true)
    }

    private func share(model: CommunityViewData) {
        let message = "Share with your friends"
        let objectsToShare = [message]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        self.controller.present(activityVC, animated: true)
    }
}
