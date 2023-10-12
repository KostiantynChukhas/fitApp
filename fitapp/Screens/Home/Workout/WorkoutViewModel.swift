//
//  WorkoutViewModel.swift
//  fitapp
//
//  Created by Sergey Pritula on 22.08.2023.
//

import Foundation
import RxSwift
import RxCocoa

class WorkoutViewModel: DeinitAnnouncerType {
    // MARK: - Private Properties
    
    private let networkService = ServiceFactory.createNetworkService()
    
    fileprivate let coordinator: WorkoutCoordinator

    private let itemsRelay = BehaviorRelay<[String]>(value: [])
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: WorkoutCoordinator) {
        self.coordinator = coordinator
        
    }
    
    func route(to route: WorkoutCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension WorkoutViewModel: ViewModelProtocol {
    struct Input {
        let backSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[String]>
        let isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackObserving(with: input.backSignal)
        ])
        
        let output = Output(
            items: itemsRelay.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false)
        )
        
        outputHandler(output)
    }
    
    private func setupBackObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.coordinator.route(to: .back)
        }
    }
    
}
