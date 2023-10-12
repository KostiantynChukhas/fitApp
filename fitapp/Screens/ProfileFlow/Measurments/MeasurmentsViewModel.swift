//
//  MeasurmentsViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class MeasurmentsViewModel: DeinitAnnouncerType {
    
    private var coordinator: MeasurmentsCoordinator
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: MeasurmentsCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: MeasurmentsCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension MeasurmentsViewModel: ViewModelProtocol {
    
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
