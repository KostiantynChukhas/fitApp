//
//  AnalyticsMeasurementsViewModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import RxSwift
import RxCocoa

class AnalyticsMeasurementsViewModel: DeinitAnnouncerType {
    
    private var coordinator: AnalyticsMeasurementsCoordinator
    
    private var networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: AnalyticsMeasurementsCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: AnalyticsMeasurementsCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension AnalyticsMeasurementsViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
    }
    
    struct Output {
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
        ])
        
        let output = Output(
        )
        
        outputHandler(output)
    }
    
   
}
