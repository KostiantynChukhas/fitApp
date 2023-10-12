//
//  HomeMyPlanViewModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import RxSwift
import RxCocoa

class HomeMyPlanViewModel: DeinitAnnouncerType {
    
    private var coordinator: HomeMyPlanCoordinator
    
    private var networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: HomeMyPlanCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: HomeMyPlanCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension HomeMyPlanViewModel: ViewModelProtocol {
    
    struct Input {
        let moreWorkoutsSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupMoreWorkoutsClickedObserving(with: input.moreWorkoutsSignal)
        ])
        
        let output = Output(
        )
        
        outputHandler(output)
    }
    
    private func setupMoreWorkoutsClickedObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.coordinator.route(to: .moreWorkouts)
        }
    }
   
}
