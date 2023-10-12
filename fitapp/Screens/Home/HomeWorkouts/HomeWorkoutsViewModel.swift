//
//  HomeWorkoutsViewModel.swift
//  fitapp
//
//  Created by Sergey Pritula on 22.08.2023.
//

import Foundation
import RxSwift
import RxCocoa

class HomeWorkoutsViewModel: DeinitAnnouncerType {
    // MARK: - Private Properties
    
    private let networkService = ServiceFactory.createNetworkService()
    
    fileprivate let coordinator: HomeWorkoutsCoordinator

    private let itemsRelay = BehaviorRelay<[WorkoutTableCellViewModel]>(value: [])
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: HomeWorkoutsCoordinator) {
        self.coordinator = coordinator
        
    }
    
    func route(to route: HomeWorkoutsCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension HomeWorkoutsViewModel: ViewModelProtocol {
    struct Input {
        let backSignal: Observable<Void>
        let modelSelected: Observable<WorkoutTableCellViewModel>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[WorkoutTableCellViewModel]>
        let isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackObserving(with: input.backSignal),
            setupFetchWorkoutsObserving(),
            setupModelSelectedObserving(with: input.modelSelected)
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
    
    private func setupFetchWorkoutsObserving() -> Disposable {
        networkService.viewWorkout(requestData: .init(limit: 100, categories: .empty, createdAtLast: nil))
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, response) in
                let data: [WorkoutTableCellViewModel] = response.data?.compactMap { .init(from: $0) } ?? []
                self.itemsRelay.accept(data)
            })
    }
    
    private func setupModelSelectedObserving(with signal: Observable<WorkoutTableCellViewModel>) -> Disposable {
        signal.bind { [weak self] in
            self?.coordinator.route(to: .workout(model: $0))
        }
    }
    
}
