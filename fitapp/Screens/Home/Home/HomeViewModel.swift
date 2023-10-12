//
//  HomeViewModel.swift
//  fitapp
//
// on 09.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

enum TypeHomePage: Int {
    case discover
    case trainers
    case myPlan
    
    func getString() -> String? {
            switch self {
            case .discover:
                return "Discover"
            case .trainers:
                return "Trainers"
            case .myPlan:
                return "My Plan"
            }
        }
}

class HomeViewModel: DeinitAnnouncerType {
    
    fileprivate let coordinator: HomeCoordinator
    
    private let selectedTypeIndex = BehaviorRelay<Int>(value: .zero)
    
    private let homeSegmentViewModel: HomeSegmentViewModel
    
    init(
        _ coordinator: HomeCoordinator,
        homeSegmentViewModel: HomeSegmentViewModel
    ) {
        self.coordinator = coordinator
        self.homeSegmentViewModel = homeSegmentViewModel
        setupDeinitAnnouncer()
    }
}

extension HomeViewModel: ViewModelProtocol {
    struct Input {
        let disposeBag: DisposeBag
        let selectedSegmentTypeIndex: Observable<Int>
        let notificationsSignal: Observable<Void>
    }
    
    struct Output {
        let homeSegmentViewModel: Observable<HomeSegmentViewModel>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupSelectedSegmentObserving(signal: input.selectedSegmentTypeIndex),
            setupNotificationsButtonObservable(with: input.notificationsSignal)
        ])
        
        let output = Output(
            homeSegmentViewModel: .just(homeSegmentViewModel)
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
