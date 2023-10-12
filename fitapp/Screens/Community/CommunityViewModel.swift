//
//  CommunityViewModel.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class CommunityViewModel: DeinitAnnouncerType {
    
    private var coordinator: CommunityCoordinator
    
    private let items = BehaviorRelay<[CommunityCellViewModel]>(value: [])
    
    private let selectedType = BehaviorRelay<TypeCommunityPage>(value: .home)
    
    private let selectedModel = BehaviorRelay<CommunityViewData?>(value: nil)
    
    private let searchTextRelay =  PublishSubject<String>()
    

    //MARK: - Properties
    
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: CommunityCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: CommunityCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension CommunityViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
        let chooseCategorySignal: Observable<CommunityCellViewModel>
        let addPostButtonSignal: Observable<Void>
        let selectedType: Observable<TypeCommunityPage>
        let searchSignal: Observable<String>
        let emptySearchSignal: Observable<Bool>
    }
    
    struct Output {
        let items: Driver<[CommunityCellViewModel]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupChooseCategorySignalObserving(signal: input.chooseCategorySignal),
            setupAddPostObserving(with: input.addPostButtonSignal),
            setupTypeModelObserving(signal: input.selectedType),
            setupSearchBarInputObserving(with: input.searchSignal),
            setupSearchObserving(with: searchTextRelay.asObservable()),
            setupEmptySearchObserving(with: input.emptySearchSignal),
            setupLikeObserving(),
            setupDislikeObserving(),
            setupCommentObserving(),
            setupShareObserving(),
            setupSectionsObservable()
        ])
        
        let output = Output(
            items: items.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
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
                self.route(to: .showDetail(model: model))
            })
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
                model.likeChangedRelay.onNext(model.isLike)
                
                if model.isDislike {
                    let dislikes = model.dislikeCount
                    model.isDislike = false
                    model.dislikeCount = max(dislikes - 1, 0)
                    model.dislikeChangedRelay.onNext(model.isDislike)
                }
                let likeData = CreateLikeCommunityRequestModel(community_id: model.model.id ?? "", is_like: newValue)
                return self.nerworkService.createLikeCommunity(requestData: likeData).asObservable()
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
                model.dislikeCount = model.isDislike ? dislikes + 1: max(dislikes - 1, 0)
                model.dislikeChangedRelay.onNext(model.isDislike)
                
                if model.isLike {
                    let likes = model.likesCount
                    model.isLike = false
                    model.likesCount = max(likes - 1, 0)
                    model.likeChangedRelay.onNext(model.isLike)
                }
                 
                let dislikeData = CreateDislikeCommunityRequestModel(community_id: model.model.id ?? "", is_dislike: newValue)
                return self.nerworkService.createDislikeCommunity(requestData: dislikeData).asObservable()
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
    
    private func setupSectionsObservable() -> Disposable {
        nerworkService
            .communityView(requestData: CommunityViewRequestModel(type_community_page: selectedType.value.getString() ?? "", search: nil))
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                let communityData: [CommunityViewData] = response.data
                
                let communityList: [CommunityCellViewModel] = communityData.compactMap { model in
                    return CommunityCellViewModel(model: model)
                }
                self.items.accept(communityList)
            })
    }
    
    private func setupSearchBarInputObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: searchTextRelay)
    }
    
    private func setupSearchObserving(with signal: Observable<String>) -> Disposable {
        return signal
            .withUnretained(self)
            .flatMap { (`self`, text) in
                return self.nerworkService.communityView(requestData: CommunityViewRequestModel(type_community_page: self.selectedType.value.getString() ?? "", search: text)).asObservable()
            }
            .subscribe(onNext: { response in
                let communityData: [CommunityViewData] = response.data
                let communityList: [CommunityCellViewModel] = communityData.compactMap { model in
                    return CommunityCellViewModel(model: model)
                }
                
                self.items.accept(communityList)
            })
    }
    
    private func setupEmptySearchObserving(with signal: Observable<Bool>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, searchIsEmpty) in
                if searchIsEmpty {
                    self.setupSectionsObservable()
                }
            })
    }
    
    private func setupAddPostObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                self.route(to: .addPost)
            })
    }
    
    private func setupChooseCategorySignalObserving(signal: Observable<CommunityCellViewModel>) -> Disposable {
        signal
            .bind { [weak self] model in
              
            }
    }
    
    private func setupTypeModelObserving(signal: Observable<TypeCommunityPage>) -> Disposable {
        signal
            .bind { [weak self] type in
                self?.selectedType.accept(type)
                self?.setupSectionsObservable()
            }
    }
}
