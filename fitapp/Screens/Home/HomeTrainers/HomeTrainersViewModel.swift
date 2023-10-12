//
//  HomeTrainersViewModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import RxSwift
import RxCocoa

class HomeTrainersViewModel: DeinitAnnouncerType {
    
    private var coordinator: HomeTrainersCoordinator
    
    private var networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let itemsRelay = BehaviorRelay<[TrainerCollectionCellViewModel]>(value: [])
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: HomeTrainersCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: HomeTrainersCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension HomeTrainersViewModel: ViewModelProtocol {
    
    struct Input {
        let indexSelected: Observable<IndexPath>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[TrainerCollectionCellViewModel]>
        let isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupFetchTrainersObserving(),
            setupIndexPathSelected(with: input.indexSelected),
            setupLikeDislikeObserving()
        ])
        
        let output = Output(
            items: itemsRelay.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false)
        )
        
        outputHandler(output)
    }
    
    private func setupFetchTrainersObserving() -> Disposable {
        self.isLoadingRelay.accept(true)
        
        return networkService.getTrainers(requestData: .init()).asObservable()
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { [weak self] response in
                let models = response.data.map { TrainerCollectionCellViewModel(trainer: $0) }
                self?.itemsRelay.accept(models)
            })
    }
    
    private func setupIndexPathSelected(with signal: Observable<IndexPath>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe { (self, indexPath) in
                let item = self.itemsRelay.value[indexPath.row]
                self.coordinator.route(to: .trainer(data: item.trainer))
            }
    }
   
    private func setupLikeDislikeObserving() -> Disposable {
        itemsRelay.asObservable()
            .flatMap { models -> Observable<TrainerCollectionCellViewModel> in
                let events = models.map { $0.likeTapObservable() }
                return Observable.merge(events)
            }
            .withUnretained(self)
            .do(onNext: { (self, model) in
                let isLiked = !model.likeRelay.value
                let currentCount = model.likeCountRelay.value
                let newCount = isLiked ? currentCount + 1: max(currentCount - 1, 0)
                model.likeRelay.accept(isLiked)
                model.likeCountRelay.accept(newCount)
            })
            .flatMap { (self, model) -> Observable<EmptyResponseModel> in
                let id = model.trainer.id
                let isLiked = !model.likeRelay.value
                
                let command = isLiked ? self.networkService.createTrainerDislike(requestData: .init(trainerId: id)):
                                        self.networkService.createTrainerLike(requestData: .init(trainerId: id))
                                        
                return command.asObservable()
            }
            .subscribe()
    }
}
