//
//  CommunityDetailViewModel.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class CommunityDetailViewModel: DeinitAnnouncerType {
    
    private var coordinator: CommunityDetailCoordinator
    
    private let sections = BehaviorRelay<[CommunityModelSectionType]>(value: [])
    
    private let commentRelay = BehaviorRelay<String>(value: .empty)
    
    private let selectedModelIndex = BehaviorRelay<IndexPath?>(value: nil)

    
    //MARK: - Properties
    
    private var selectedIndexes = Set<Int>()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let isClearTextFieldRelay = BehaviorRelay<Void>(value: ())
    
    private let replySelectedRelay = BehaviorRelay<CommunityCommentsData?>(value: nil)
   
    private let moreSelectedRelay = BehaviorRelay<CommunityCommentsData?>(value: nil)

    private let nerworkService = ServiceFactory.createNetworkService()
    
    private let descriptionModel: CommunityCellViewModel
    
    init(_ coordinator: CommunityDetailCoordinator, model: CommunityCellViewModel) {
        self.coordinator = coordinator
        self.descriptionModel = model
        setupDeinitAnnouncer()
    }
    
    func route(to route: CommunityDetailCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension CommunityDetailViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
        let backSignal: Observable<Void>
        let commentText: Observable<String>
        let modelIndexSelected: Observable<IndexPath>
        let modelSelected: Observable<CommunityModelSectionType>
        let sendCommentSignal: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<[CommunityModelSectionType]>
        let isLoading: Driver<Bool>
        let isClearTextField: Driver<Void>
        let replySelected: Driver<CommunityCommentsData?>
        let moreSelected: Driver<CommunityCommentsData?>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackObserving(with: input.backSignal),
            setupCommentTextObserving(with: input.commentText),
            setupSelectedIdObserving(with: input.modelIndexSelected),
            setupModelSelectedObserving(with: input.modelSelected),
            setupSendCommentObserving(with: input.sendCommentSignal),
            setupReplyObserving(),
            setupLikeObserving(),
            setupDislikeObserving(),
            setupShareObserving(),
            setupHeaderLikeObserving(),
            setupHeaderDislikeObserving(),
            setupLibrariesCommentsObserbing()
        ])
        
        let output = Output(
            sections: sections.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false),
            isClearTextField: isClearTextFieldRelay.asDriver(),
            replySelected: replySelectedRelay.asDriver(onErrorJustReturn: nil),
            moreSelected: moreSelectedRelay.asDriver(onErrorJustReturn: nil)
        )
        
        outputHandler(output)
        setupSections()
    }
    
    private func setupSections() {
        let initialValue: [CommunityModelSectionType] = [
            .description(model: descriptionModel)
        ]
        
        self.sections.accept(initialValue)
    }
    
    private func setupSendCommentObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .flatMap { [self] in
                return self.nerworkService.addCommentCommunity(requestData: .init(comments: self.commentRelay.value, community_id: self.descriptionModel.model.id ?? "", answer_comment_id: self.replySelectedRelay.value?.id ?? nil))
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(false)
                self?.isClearTextFieldRelay.accept(())
            })
            .subscribe(onNext: { (`self`, response) in
                guard let model = response.data else { return }
                var currentSections = self.sections.value
                currentSections.append(contentsOf: [.comments(model: .init(commentsModel: model, isNested: false))])
                self.sections.accept(currentSections)
                self.replySelectedRelay.accept(nil)
            })
    }
    
    private func setupSelectedIdObserving(with signal: Observable<IndexPath>) -> Disposable {
        signal
            .filter { [weak self] indexPath in
                let index = indexPath.row
                self?.selectedModelIndex.accept(nil)
                guard let selectedIndexes = self?.selectedIndexes, !selectedIndexes.contains(index) else { return false }
                return true
            }
            .subscribe(onNext: { [weak self] indexPath in
                let index = indexPath.row
                self?.selectedIndexes.insert(index)
                self?.selectedModelIndex.accept(indexPath)
            })
    }
    
    private func setupModelSelectedObserving(with signal: Observable<CommunityModelSectionType>) -> Disposable {
        signal
            .flatMap { cellModel -> Observable<CommunityArticleCommentsModel> in
                if case let .comments(model) = cellModel { return .just(model) }
                return .never()
            }
            .withUnretained(self)
            .flatMapLatest { (self, model) in
                return self.nerworkService.getCommunityComments(requestData: .init(
                    limit: 1000,
                    community_id: self.descriptionModel.model.id ?? "",
                    answer_comment_id: model.model.id ?? ""
                )
                )}
            .subscribe(onNext: { [weak self] response in
                let responseModel: [CommunityCommentsData] = response.data ?? []
                var responseSections: [CommunityModelSectionType] = []
                responseModel.forEach {
                    responseSections.append(contentsOf: [.comments(model: .init(
                        commentsModel: $0,
                        isNested: true
                    ))])
                }
                
                guard let row = self?.selectedModelIndex.value?.row else { return }
                var currentArray = self?.sections.value
                currentArray?.insert(contentsOf: responseSections, at: row + 1)
                self?.sections.accept(currentArray ?? [])
            })
    }
    
    private func setupLibrariesCommentsObserbing() -> Disposable {
        nerworkService
            .getCommunityComments(
                requestData: CommunityCommentsRequestModel(community_id: self.descriptionModel.model.id ?? "")
            )
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                let model: [CommunityCommentsData] = response.data ?? []
                
                model.forEach {
                    var currentSections = self.sections.value
                    currentSections.append(contentsOf: [.comments(model: .init(commentsModel: $0, isNested: false))])
                    self.sections.accept(currentSections)
                }
            })
    }
    
    private func setupCommentTextObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: commentRelay)
    }
    
    private func setupBackObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                self.route(to: .back)
            })
    }
    
    private func setupReplyObserving() -> Disposable {
        sections
            .asObservable()
            .flatMap { cellModel -> Observable<[CommunityArticleCommentsModel]> in
                return Observable.just(cellModel.compactMap {
                    if case let .comments(model) = $0 { return model }
                    return nil
                })
            }
            .flatMap { models in
                let events = models.map { $0.replyTapObservable() }
                return Observable.merge(events)
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] model in
                self?.replySelectedRelay.accept(model)
            })
    }
    
    private func setupMoreObserving() -> Disposable {
        sections
            .asObservable()
            .flatMap { cellModel -> Observable<[CommunityArticleCommentsModel]> in
                return Observable.just(cellModel.compactMap {
                    if case let .comments(model) = $0 { return model }
                    return nil
                })
            }
            .flatMap { models in
                let events = models.map { $0.moreTapObservable() }
                return Observable.merge(events)
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] model in
                self?.moreSelectedRelay.accept(model)
            })
    }
    
    private func setupLikeObserving() -> Disposable {
        sections
            .asObservable()
            .flatMap { cellModel -> Observable<[CommunityArticleCommentsModel]> in
                return Observable.just(cellModel.compactMap {
                    if case let .comments(model) = $0 { return model }
                    return nil
                })
            }
            .flatMap { models in
                let events = models.map { $0.likeTapObservable() }
                return Observable.merge(events)
            }
            .withUnretained(self)
            .flatMapLatest { (`self`, model) in
                let newValue = !model.isLike
                model.isLike = newValue
                let likes = model.likesCount
                model.likesCount = model.isLike ? likes + 1: max(likes - 1, 0)
                model.likeChangedRelay.onNext(model.isLike)
                
                if model.isDislike {
                    model.isDislike = false
                    let dislikes = model.dislikeCount
                    model.dislikeCount = max(dislikes - 1, 0)
                    model.dislikeChangedRelay.onNext(model.isDislike)
                }
                
                let data = CreateLikeCommentRequestModel(comment_id: model.model.id ?? "", is_like: newValue)
                return self.nerworkService.createLikeCommunityComment(requestData: data).asObservable()
                    .catch { _ in .empty() }
            }
            .subscribe(onNext: { _ in })
    }
    
    private func setupDislikeObserving() -> Disposable {
        sections
            .asObservable()
            .flatMap { cellModel -> Observable<[CommunityArticleCommentsModel]> in
                return Observable.just(cellModel.compactMap {
                    if case let .comments(model) = $0 { return model }
                    return nil
                })
            }
            .flatMap { models in
                let events = models.map { $0.dislikeTapObservable() }
                return Observable.merge(events)
            }
            .withUnretained(self)
            .flatMapLatest { (`self`, model) in
                let newValue = !model.isDislike
                model.isDislike = newValue
                let dislikes = model.dislikeCount
                model.dislikeCount = model.isDislike ? dislikes + 1: max(dislikes - 1, 0)
                model.dislikeChangedRelay.onNext(model.isDislike)
                
                if model.isLike {
                    model.isLike = false
                    let likes = model.likesCount
                    model.likesCount = max(likes - 1, 0)
                    model.likeChangedRelay.onNext(model.isLike)
                }
                
                let data = CreateDislikeCommentRequestModel(comment_id: model.model.id ?? "", is_dislike: newValue)
                return self.nerworkService.createDislikeCommunityComment(requestData: data).asObservable()
                    .catch { _ in .empty() }
            }
            .subscribe(onNext: { _ in })
    }
    
    private func setupShareObserving() -> Disposable {
        descriptionModel.shareTapObservable()
            .subscribe(onNext: { model in
                self.coordinator.route(to: .share(model: model))
            })
    }

    private func setupHeaderLikeObserving() -> Disposable {
        descriptionModel.likeTapObservable()
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
    
    private func setupHeaderDislikeObserving() -> Disposable {
        descriptionModel.dislikeTapObservable()
            .withUnretained(self)
            .flatMapLatest { (`self`, model) in
                let newValue = !model.isDislike
                model.isDislike = newValue
                let dislikes = model.dislikeCount
                model.dislikeCount = model.isDislike ? dislikes + 1: max(dislikes - 1, 0)
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
}
