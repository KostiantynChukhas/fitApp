//
//  ForgotPasswordDoneViewModel.swift
//  fitapp
//
//   on 06.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class ForgotPasswordDoneViewModel: DeinitAnnouncerType {

    private var coordinator: ForgotPasswordDonePopupCoordinator

    // MARK: - Observabled
    
    init(_ coordinator: ForgotPasswordDonePopupCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: ForgotPasswordDonePopupCoordinator.Route) {
        coordinator.route(to: route)
    }

}

// MARK: - ViewModelProtocol

extension ForgotPasswordDoneViewModel: ViewModelProtocol {
    
    struct Input {
        let continueSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {}
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupContinueClickedObserving(with: input.continueSignal)
        ])
        
        let output = Output()
        outputHandler(output)
    }
    
    private func setupContinueClickedObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                self.route(to: .back)
            })
    }
}
