//
//  ReviewTrainerViewModel.swift
//  fitapp
//
//  Created by  on 23.07.2023.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewTrainerViewModel: DeinitAnnouncerType {
    
    // MARK: - Private Properties
    
    private let networkService = ServiceFactory.createNetworkService()
    
    fileprivate let coordinator: ReviewTrainerCoordinator
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let reviewTextRelay = BehaviorRelay<String>(value: "")
    
    private let starRelay = BehaviorRelay<Int>(value: .zero)
    
    private let imagesRelay = BehaviorRelay<[PhotoModel]>(value: [])
    
    private let validationRelay = BehaviorRelay<Bool>(value: false)
    
    private let trainerId: String
    
    init(_ coordinator: ReviewTrainerCoordinator, id: String) {
        self.coordinator = coordinator
        self.trainerId = id
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: ReviewTrainerCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension ReviewTrainerViewModel: ViewModelProtocol {
    struct Input {
        let reviewSignal: Observable<Void>
        let closeSignal: Observable<Void>
        let textSignal: Observable<String>
        let starSignal: Observable<Int>
        let addPhotoSignal: Observable<UIImage>
        let removePhotoSignal: Observable<PhotoModel>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let isValid: Driver<Bool>
        let images: Driver<[PhotoModel]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupReviewButtonObserving(with: input.reviewSignal),
            setupCloseButtonObserving(with: input.closeSignal),
            setupTextObserving(with: input.textSignal),
            setupStarsObserving(with: input.starSignal),
            setupValidationObserving(),
            setupAddPhotoObserving(with: input.addPhotoSignal),
            setupRemovePhotoObserving(with: input.removePhotoSignal)
        ])
        
        let output = Output(
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false),
            isValid: validationRelay.asDriver(onErrorJustReturn: false),
            images: imagesRelay.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
    }
    
    private func setupReviewButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { (self, _) in
                self.isLoadingRelay.accept(true)
                
                let images = self.imagesRelay.value.map { $0.image.compressToData(sizeInKb: 300) ?? Data() }
                return self.networkService.createTrainerReview(requestData: .init(
                    description: self.reviewTextRelay.value,
                    star: self.starRelay.value,
                    trainerId: self.trainerId,
                    picture: images)
                ).asObservable()
            }
            .withUnretained(self)
            .subscribe { (self, response) in
                self.isLoadingRelay.accept(false)
                self.coordinator.route(to: .reviewDone)
            }
    }
    
    private func setupCloseButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.coordinator.route(to: .dismiss)
        }
    }
    
    private func setupTextObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: reviewTextRelay)
    }
    
    private func setupStarsObserving(with signal: Observable<Int>) -> Disposable {
        signal.bind(to: starRelay)
    }
    
    private func setupValidationObserving() -> Disposable {
        Observable.combineLatest(reviewTextRelay.asObservable(), starRelay.asObservable())
            .subscribe { [weak self] (review, stars) in
                guard let self = self else { return }
                
                let isValid = !review.isEmpty && stars > 0
                self.validationRelay.accept(isValid)
            }
    }
    
    private func setupAddPhotoObserving(with signal: Observable<UIImage>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (self, image) in
                var images = self.imagesRelay.value
                images.append(.init(uuid: .init(), image: image))
                self.imagesRelay.accept(images)
            })
    }
    
    private func setupRemovePhotoObserving(with signal: Observable<PhotoModel>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (self, model) in
                var images = self.imagesRelay.value
                images.removeAll(where: { $0.uuid == model.uuid })
                self.imagesRelay.accept(images)
            })
    }
    
    
}
