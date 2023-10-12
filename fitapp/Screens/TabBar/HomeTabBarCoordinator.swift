//
//  TabBarCoordinator.swift
//  fitapp
//
//  Created by on 12.05.2023.
//

import Foundation
import RxSwift

protocol HomeTabBarCoordinatorTransitions: AnyObject {
    func logout()
}

final class HomeTabBarCoordinator: Coordinator<Void> {
    
    struct Injections {
        let window: UIWindow
        let navigationController: UINavigationController
    }
    
    private let injections: Injections
    var tabBarController: HomeTabBarController!

    private var tabs: [TabBarType]
    
    weak var transitions: HomeTabBarCoordinatorTransitions?
    
    private var defaultTabs: [TabBarType] = [.home, .community, .library, .analytics, .profile]
    private var defaultSelectedTab: TabBarType = .home
    
    private let selectTabEvent: PublishSubject<TabBarType> = .init()
    private let selectedTabEvent: PublishSubject<TabBarType> = .init()
    private let refreshTabEvent: PublishSubject<TabBarType> = .init()
    private let animateTabEvent: PublishSubject<TabBarType> = .init()
    
    init(injections: Injections) {
        self.injections = injections
        self.tabs = defaultTabs
        self.defaultSelectedTab = self.tabs[0]
    }
    
    override func start() -> Observable<Void> {
        
        let viewModel = HomeTabBarViewModel(injections: .init(tabs: tabs, defaultSelectedTab: defaultSelectedTab))
        tabBarController = HomeTabBarController(viewModel: viewModel)
        injections.window.rootViewController = tabBarController
        injections.window.makeKeyAndVisible()
    
        // Coordinate to all tabs
        coordinateToTabs(tabs)
        
        // Select Tab Event
        Observable.merge([viewModel.tabTypeTapEvent])
            .bind(to: selectTabEvent)
            .disposed(by: disposeBag)
        
        // Select Tab by verify login if required
        selectTabEvent
            .bind(to: viewModel.selectedTabType)
            .disposed(by: disposeBag)
        
        // Animate tab bar on refresh event
        animateTabEvent
            .bind(to: viewModel.animateTabTypeEvent)
            .disposed(by: disposeBag)
        
        // Refresh tab event
        viewModel.refreshTabEvent
            .bind(to: refreshTabEvent)
            .disposed(by: disposeBag)
        
        viewModel.selectedTabType
            .bind(to: selectedTabEvent)
            .disposed(by: disposeBag)

        return .never()
    }
    
    private func coordinateToTabs(_ tabs: [TabBarType]) {
        tabs.forEach { tabType in
            switch tabType {
            case .home: coordinateToHome(tabBarController: tabBarController)
            case .community: coordinateToCommunity(tabBarController: tabBarController)
            case .library: coordinateToLibrary(tabBarController: tabBarController)
            case .analytics: coordinateToAnalytics(tabBarController: tabBarController)
            case .profile: coordinateToProfile(tabBarController: tabBarController)
            }
        }
        tabBarController.reload()
        selectTabEvent.onNext(defaultSelectedTab)
    }
    
}

extension HomeTabBarCoordinator {
    
    private func coordinateToHome(tabBarController: HomeTabBarController) {
        let coordinator = HomeCoordinator(tabBarController: tabBarController)
        coordinator.route(to: .`self`)
    }
    
    private func coordinateToCommunity(tabBarController: HomeTabBarController) {
        let coordinator = CommunityCoordinator(tabBarController: tabBarController)
        coordinator.route(to: .`self`)
    }
    
    private func coordinateToLibrary(tabBarController: HomeTabBarController) {
        let coordinator = LibraryCoordinator(tabBarController: tabBarController)
        coordinator.route(to: .`self`)
    }
    
    private func coordinateToAnalytics(tabBarController: HomeTabBarController) {
        let coordinator = AnalyticsCoordinator(tabBarController: tabBarController)
        coordinator.route(to: .`self`)
    }
    
    private func coordinateToProfile(tabBarController: HomeTabBarController) {
        guard let user = SessionManager.shared.user else { return }
        
        let coordinator = ProfileCoordinator(
            config: .tabBar(controller: tabBarController),
            type: .ownProfile(model: user)
        )
        
        coordinator.transitions = self
        coordinator.route(to: .`self`)
    }
     
}

extension HomeTabBarCoordinator: ProfileCoordinatorTransitions {
    func logout() {
        transitions?.logout()
    }
}
