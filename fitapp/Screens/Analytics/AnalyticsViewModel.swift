//
//  AnalyticsViewModel.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

enum TypeAnalyticsage: Int {
    case stats
    case measurements
    
    func getString() -> String? {
            switch self {
            case .stats:
                return "Stats"
            case .measurements:
                return "Measurements"
           
            }
        }
}

class AnalyticsViewModel: DeinitAnnouncerType {
    
    private let selectedTypeIndex = BehaviorRelay<Int>(value: .zero)
    
    private let analyticsSegmentViewModel: AnalyticsSegmentViewModel

    private var coordinator: AnalyticsCoordinator
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: AnalyticsCoordinator,
         analyticsSegmentViewModel: AnalyticsSegmentViewModel) {
        self.coordinator = coordinator
        self.analyticsSegmentViewModel = analyticsSegmentViewModel
        setupDeinitAnnouncer()
    }
    
    func route(to route: AnalyticsCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension AnalyticsViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
        let selectedSegmentTypeIndex: Observable<Int>
        let notificationsSignal: Observable<Void>
    }
    
    struct Output {
        let analyticsSegmentViewModel: Observable<AnalyticsSegmentViewModel>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupSelectedSegmentObserving(signal: input.selectedSegmentTypeIndex),
            setupNotificationsButtonObservable(with: input.notificationsSignal)
        ])
        
        let output = Output(
            
            analyticsSegmentViewModel: .just(analyticsSegmentViewModel)
        )
        
        outputHandler(output)
    }
    
    private func setupSelectedSegmentObserving(signal: Observable<Int>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { [weak self] index in
                
            })
    }
    
    private func setupNotificationsButtonObservable(with signal: Observable<Void>) -> Disposable  {
        signal.bind { [weak self] in
            self?.coordinator.route(to: .notifications)
        }
    }
    
}

