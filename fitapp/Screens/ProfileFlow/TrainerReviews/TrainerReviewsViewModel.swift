//
//  TrainerReviewsViewModel.swift
//  fitapp
//
//  Created by  on 29.07.2023.
//

import Foundation
import RxSwift
import RxCocoa

enum ReviewItem {
    case reviewInfo(data: TrainerData)
    case userReview(model: TrainerReviewData)
}

class TrainerReviewsViewModel: DeinitAnnouncerType {
    
    // MARK: - Private Properties
    
    private let networkService = ServiceFactory.createNetworkService()
    
    fileprivate let coordinator: TrainerReviewsCoordinator
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let itemsRelay = BehaviorRelay<[ReviewItem]>(value: [])
    
    private let reloadSubject = PublishSubject<Void>()
    
    private let type: ProfileType
    
    init(_ coordinator: TrainerReviewsCoordinator, type: ProfileType) {
        self.coordinator = coordinator
        self.type = type
    }
    
    func route(to route: TrainerReviewsCoordinator.Route) {
        coordinator.route(to: route)
    }
    
    func reload() {
        reloadSubject.onNext(())
    }
}

extension TrainerReviewsViewModel: ViewModelProtocol {
    struct Input {
        let reviewSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let items: Driver<[ReviewItem]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupFetchTrainerReviewsObserving(),
            setupReviewButtonObserving(with: input.reviewSignal)
        ])
        
        let output = Output(
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false),
            items: itemsRelay.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
        reload()
    }
    
    private func setupFetchTrainerReviewsObserving() -> Disposable {
        reloadSubject
            .withUnretained(self)
            .flatMap { (self, _) in
                self.isLoadingRelay.accept(true)
                return self.networkService.getTrainerReviews(requestData: .init(), id: self.type.id).asObservable()
            }
            .withUnretained(self)
            .subscribe(onNext: { (self, response) in
                var items: [ReviewItem] = response.data.map { .userReview(model: $0) }
                
                if case .trainer(let data) = self.type {
                    items.insert(.reviewInfo(data: data), at: .zero)
                }
                
                self.itemsRelay.accept(items)
                self.isLoadingRelay.accept(false)
            })
    }
    
    private func setupReviewButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.coordinator.route(to: .review)
        }
    }
}
