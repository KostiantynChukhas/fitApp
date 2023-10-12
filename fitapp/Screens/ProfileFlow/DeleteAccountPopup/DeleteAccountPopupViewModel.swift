//
//  DeleteAccountPopupViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class DeleteAccountPopupViewModel: DeinitAnnouncerType {
    
    private var coordinator: DeleteAccountPopupCoordinator
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: DeleteAccountPopupCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: DeleteAccountPopupCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension DeleteAccountPopupViewModel: ViewModelProtocol {
    
    struct Input {
        let cancelSignal: Observable<Void>
        let deleteSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupCancelObserving(with: input.cancelSignal),
            setupDeleteObserving(with: input.deleteSignal)
        ])
        
        let output = Output(
            
        )
        
        outputHandler(output)
    }
    
    private func setupCancelObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.coordinator.route(to: .back)
        }
    }
    
    private func setupDeleteObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.coordinator.route(to: .logout)
        }
    }
    
}
