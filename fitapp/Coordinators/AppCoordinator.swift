//
//  AppCoordinator.swift
//  fitapp
//

import Foundation
import UIKit

class AppCoordinator {
    private var window: UIWindow
    private let serviceHolder = ServiceHolder.shared

    private var authCoordinator: AuthCoordinator?
    private var onboardingAppCoordinator: OnboardingAppCoordinator?
    private var mainCoordinator: MainCoordinator?


    init(window: UIWindow) {
        self.window = window
        start()
    }

    func start() {
        if UDProvider.onboardingWasShown {
            startAuth()
        } else {
            startOnboarding()
        }
    }

    private func startAuth() {
        authCoordinator = AuthCoordinator(window: window)
        authCoordinator?.transitions = self
        authCoordinator?.start()
    }
    
    private func startOnboarding() {
        onboardingAppCoordinator = OnboardingAppCoordinator(window: window)
        onboardingAppCoordinator?.transitions = self
        onboardingAppCoordinator?.start()
    }
    
    private func startMain() {
        mainCoordinator = MainCoordinator(window: window)
        mainCoordinator?.transitions = self
        mainCoordinator?.start()
    }
}

// MARK: - AuthCoordinatorTransitions -

extension AppCoordinator: AuthCoordinatorTransitions, OnboardingAppCoordinatorTransitions, MainCoordinatorTransitions {
    func showLogin() {
        
    }
    
    func didLogOut() {
        startAuth()
        LibraryCategoryService.shared.clear()
    }
    
    func onboardingWasShown() {
        UDProvider.onboardingWasShown = true
        startAuth()
    }
    
    func showMain() {
        startMain()
    }
    
}
