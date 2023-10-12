//
//  ProfileFeedsViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileFeedsViewModel: DeinitAnnouncerType {
    
    private var coordinator: ProfileFeedsCoordinator
    
    private var networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let items = BehaviorRelay<[CommunityCellViewModel]>(value: [])
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    private let type: ProfileType
    
    init(_ coordinator: ProfileFeedsCoordinator, type: ProfileType) {
        self.coordinator = coordinator
        self.type = type
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: ProfileFeedsCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension ProfileFeedsViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[CommunityCellViewModel]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupFeedObserving(for: type.id),
            setupLikeObserving(),
            setupDislikeObserving(),
            setupShareObserving(),
            setupCommentObserving()
        ])
        
        let output = Output(
            items: items.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
    }
    
    private func setupFeedObserving(for id: String) -> Disposable {
        networkService.getFeed(requestData: .init(createdAtLast: .zero), userId: id)
            .asObservable()
            .withUnretained(self)
            .subscribe { (`self`, response) in
                let communityData: [CommunityViewData] = response.data
                
                let communityList: [CommunityCellViewModel] = communityData.compactMap { model in
                    return CommunityCellViewModel(model: model)
                }
                self.items.accept(communityList)
            }
    }
    
    private func setupLikeObserving() -> Disposable {
        items
            .asObservable()
            .flatMap { models -> Observable<CommunityCellViewModel> in
                let events = models.map { $0.likeTapObservable() }
                return Observable.merge(events)
            }
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { (`self`, model) in
                let newValue = !model.isLike
                model.isLike = newValue
                let likes = model.likesCount
                model.likesCount = model.isLike ? likes + 1: max(likes - 1, 0)
                model.likeChangedRelay.onNext(newValue)
                
                if model.isDislike {
                    model.isDislike = false
                    let dislikes = model.dislikeCount
                    model.dislikeCount = max(dislikes - 1, 0)
                    model.dislikeChangedRelay.onNext(model.isDislike)
                }
                
                let data = CreateLikeCommunityRequestModel(community_id: model.model.id ?? "", is_like: newValue)
                return self.nerworkService.createLikeCommunity(requestData: data).asObservable()
                    .catch { _ in .empty() }
            }
            .subscribe(onNext: { _ in })
    }
    
    private func setupDislikeObserving() -> Disposable {
        items
            .asObservable()
            .flatMap { models -> Observable<CommunityCellViewModel> in
                let events = models.map { $0.dislikeTapObservable() }
                return Observable.merge(events)
            }
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { (`self`, model) in
                let newValue = !model.isDislike
                model.isDislike = newValue
                let dislikes = model.dislikeCount
                model.dislikeCount = newValue ? dislikes + 1: max(dislikes - 1, 0)
                model.dislikeChangedRelay.onNext(newValue)

                if model.isLike {
                    model.isLike = false
                    let likes = model.likesCount
                    model.likesCount = max(likes - 1, 0)
                    model.likeChangedRelay.onNext(model.isLike)
                }
                
                let data = CreateDislikeCommunityRequestModel(community_id: model.model.id ?? "", is_dislike: newValue)
                return self.nerworkService.createDislikeCommunity(requestData: data).asObservable()
                    .catch { _ in .empty() }
            }
            .subscribe(onNext: { _ in })
    }
    
    private func setupShareObserving() -> Disposable {
        items
            .asObservable()
            .flatMap { models -> Observable<CommunityViewData> in
                let events = models.map { $0.shareTapObservable() }
                return Observable.merge(events)
            }
            .asObservable()
            .withUnretained(self)
            .subscribe { (`self`, model) in
                self.coordinator.route(to: .share(model: model))
            }
    }
    
    private func setupCommentObserving() -> Disposable {
        items
            .asObservable()
            .flatMapLatest { models -> Observable<CommunityCellViewModel> in
                let events = models.map { $0.commentTapObservable() }
                return Observable.merge(events)
            }
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, model) in
                self.coordinator.route(to: .showDetail(model: model))
            })
    }
    
}
