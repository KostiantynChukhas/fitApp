//
//  LoginPreviewViewModel.swift
//  StartProjectsMVVM + C
//

import Foundation

protocol LoginPreviewViewModelType {
    func route(to route: LoginPreviewCoordinator.Route)
}

class LoginPreviewViewModel: LoginPreviewViewModelType, DeinitAnnouncerType {
    
    fileprivate let coordinator: LoginPreviewCoordinator
    
    init(_ coordinator: LoginPreviewCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
}

extension LoginPreviewViewModel {
    func route(to route: LoginPreviewCoordinator.Route) {
        coordinator.route(to: route)
    }
}
