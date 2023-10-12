//
//  ForgotPasswordViewModel.swift
//  fitapp
//

import Foundation
import RxSwift
import RxCocoa

class ForgotPasswordViewModel: DeinitAnnouncerType {
    
    fileprivate let coordinator: ForgotPasswordCoordinator
    
    // MARK: - Observables
    
    private let emailRelay = BehaviorRelay<String>(value: .empty)
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: ForgotPasswordCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
}

extension ForgotPasswordViewModel: ViewModelProtocol {
    struct Input {
        let backSignal: Observable<Void>
        let email: Observable<String>
        let sendSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupEmailObserving(with: input.email),
            setupBackSignalObserving(with: input.backSignal),
            setupSendSignalObserving(with: input.sendSignal)
        ])
        
        let output = Output(
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false)
        )
        
        outputHandler(output)
    }
    
    private func setupEmailObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: emailRelay)
    }
    
    private func setupBackSignalObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.route(to: .back)
        }
    }
    
    private func setupSendSignalObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.route(to: .done)
        }
    }
}

// MARK: - Navigation

extension ForgotPasswordViewModel {
    func route(to route: ForgotPasswordCoordinator.Route) {
        coordinator.route(to: route)
    }
}
