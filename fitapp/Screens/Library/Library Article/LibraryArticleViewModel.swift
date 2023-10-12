//
//  LibraryArticleViewModel.swift
//  fitapp
//
//  on 13.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class LibraryArticleViewModel: DeinitAnnouncerType {
    // MARK: - Private Properties
    
    private let sections = BehaviorRelay<[LibraryModelSectionType]>(value: [])
        
    private let selectedModelIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    private let commentRelay = BehaviorRelay<String>(value: .empty)
    
    private let nestedNameRelay = BehaviorRelay<String>(value: .empty)
    
    private let nestedCommentRelay = BehaviorRelay<String>(value: .empty)
        
    private var service = FitappNetworkService(baseURL: FitappURLs.getBaseURl(for: .release))
    
    fileprivate let coordinator: LibraryArticleCoordinator
    
    //MARK: - Properties
    
    private let descriptionModel: LibraryArticleDescriptionCellViewModel
    
    private var model: LibraryData
    
    private var selectedIndexes = Set<Int>()

    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let isClearTextFieldRelay = BehaviorRelay<Void>(value: ())
    private let scrollToBottomRelay = BehaviorRelay<Void>(value: ())

    private let replySelectedRelay = BehaviorRelay<LibraryCommentsData?>(value: nil)
    private let moreSelectedRelay = BehaviorRelay<LibraryCommentsData?>(value: nil)
    
    private let isSavedRelay = BehaviorRelay<Bool>(value: false)
    
    private let networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observable
    
    init(_ coordinator: LibraryArticleCoordinator, model: LibraryData) {
        self.coordinator = coordinator
        self.model = model
        
        self.descriptionModel = .init(
            id: model.id,
            text: model.content.html2String,
            nameAuthor: model.modelCreator.name ?? "",
            typeUser: model.modelCreator.role ?? "",
            time:  Date(timeIntervalSince1970: TimeInterval(model.createdAt) ?? 0.0).toString(format:"dd.MM.yyyy HH:mm"),
            imgUrl: model.picture,
            imgAvatarUrl: model.modelCreator.avatar ?? ""
        )
        
        self.isSavedRelay.accept(model.isSave)
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: LibraryArticleCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension LibraryArticleViewModel: ViewModelProtocol {
    struct Input {
        let disposeBag: DisposeBag
        let backButtonSignal: Observable<Void>
        let modelIndexSelected: Observable<IndexPath>
        let modelSelected: Observable<LibraryModelSectionType>
        let commentText: Observable<String>
        let sendCommentSignal: Observable<Void>
        let markSignal: Observable<Void>
        let moreItemSelected: Observable<DropDownItem>
        let dropDownDismissed: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<[LibraryModelSectionType]>
        let isLoading: Driver<Bool>
        let isClearTextField: Driver<Void>
        let scrollToBottom: Driver<Void>
        let replySelected: Driver<LibraryCommentsData?>
        let moreSelected: Driver<LibraryCommentsData?>
        let isSaved: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackButtonObserbing(with: input.backButtonSignal),
            setupLibrariesCommentsObserbing(),
            setupSelectedIdObserving(with: input.modelIndexSelected),
            setupModelSelectedObserving(with: input.modelSelected),
            setupSendCommentObserving(with: input.sendCommentSignal),
            setupCommentTextObserving(with: input.commentText),
            setupReplyObserving(),
            setupMoreObserving(),
            setupLikeObserving(),
            setupDislikeObserving(),
            setupMarkObserving(with: input.markSignal),
            setupMoreActionObserving(with: input.moreItemSelected),
            setupDropDownDismissObserving(with: input.dropDownDismissed)
        ])
        
        let output = Output(
            sections: sections.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false),
            isClearTextField: isClearTextFieldRelay.asDriver(),
            scrollToBottom: scrollToBottomRelay.asDriver(),
            replySelected: replySelectedRelay.asDriver(onErrorJustReturn: nil),
            moreSelected: moreSelectedRelay.asDriver(onErrorJustReturn: nil),
            isSaved: isSavedRelay.asDriver(onErrorJustReturn: false)
        )
        
        outputHandler(output)
        setupSections()
        
    }
    
    private func setupSections() {
        let initialValue: [LibraryModelSectionType] = [
            .description(model: descriptionModel)
        ]
        
        self.sections.accept(initialValue)
    }
    
    private func setupReplyObserving() -> Disposable {
        sections
            .asObservable()
            .flatMap { cellModel -> Observable<[LibraryArticleCommentsModel]> in
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
            .flatMap { cellModel -> Observable<[LibraryArticleCommentsModel]> in
                return Observable.just(cellModel.compactMap {
                    if case let .comments(model) = $0 { return model }
                    return nil
                })
            }
            .flatMap { models in
                let events = models.map { $0.moreTapObservable() }
                return Observable.merge(events)
            }
            .subscribe(onNext: { [weak self] model in
                self?.moreSelectedRelay.accept(model)
            })
    }
    
    private func setupLikeObserving() -> Disposable {
        sections
            .asObservable()
            .flatMap { cellModel -> Observable<[LibraryArticleCommentsModel]> in
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
                print("-> comment model \(model)")
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
                let data = CreateLikeCommentRequestModel(comment_id: model.commentsModel.id ?? "", is_like: newValue)
                return self.networkService.createLikeLibraryComment(requestData: data).asObservable()
                    .catch { _ in .empty() }
            }
            .subscribe(onNext: { _ in })
    }
    
    private func setupDislikeObserving() -> Disposable {
        sections
            .asObservable()
            .flatMap { cellModel -> Observable<[LibraryArticleCommentsModel]> in
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
                model.dislikeChangedRelay.onNext(newValue)

                if model.isLike {
                    model.isLike = false
                    let likes = model.likesCount
                    model.likesCount = max(likes - 1, 0)
                    model.likeChangedRelay.onNext(model.isLike)
                }
                let data = CreateDislikeCommentRequestModel(comment_id: model.commentsModel.id ?? "", is_dislike: newValue)
                return self.networkService.createDislikeLibraryComment(requestData: data).asObservable()
                    .catch { _ in .empty() }
            }
            .subscribe(onNext: { _ in })
    }
    
    private func setupSendCommentObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .flatMap { [self] in
                return self.service.addCommentLibrary(requestData: .init(comments: self.commentRelay.value, library_id: self.descriptionModel.id, answer_comment_id:  self.replySelectedRelay.value?.id ?? nil))
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(false)
                self?.isClearTextFieldRelay.accept(())
            })
            .subscribe(onNext: { (`self`, response) in
                guard let model: LibraryCommentsData = response.data else { return }
                
                let containsComments = self.sections.value.contains { section in
                    if case .comments = section {
                        return true
                    }
                    return false
                }
                
                var currentSections = self.sections.value
                currentSections.append(contentsOf: [.comments(model: .init(commentsModel: model, isNested: false))])
                self.sections.accept(currentSections)
                self.replySelectedRelay.accept(nil)
                self.scrollToBottomRelay.accept(())
            })
    }
    
    private func setupMoreActionObserving(with signal: Observable<DropDownItem>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, item) in
                // TODO: -TN- Implement logic for needed cases!
                switch item {
                case .profile:
                    break
                case .reportComment:
                    break
                case .reportUser:
                    break
                default:
                    break
                }
                self.moreSelectedRelay.accept(nil)
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
    
    private func setupModelSelectedObserving(with signal: Observable<LibraryModelSectionType>) -> Disposable {
        signal
            .flatMap { cellModel -> Observable<LibraryArticleCommentsModel> in
                if case let .comments(model) = cellModel { return .just(model) }
                return .never()
            }
            .withUnretained(self)
            .flatMapLatest { (self, model) in
                self.nestedCommentRelay.accept(model.commentsModel.comments ?? "")
                self.nestedNameRelay.accept(model.commentsModel.modelAccount?.name ?? "")
                return self.service.getLibraryComments(requestData: .init(
                    limit: 1000,
                    library_id: model.commentsModel.libraryID ?? "",
                    answer_comment_id: model.commentsModel.id ?? "")
                )
            }
            .subscribe(onNext: { [weak self] response in
                let responseModel: [LibraryCommentsData] = response.data
                var responseSections: [LibraryModelSectionType] = []
                responseModel.forEach {
                    responseSections.append(contentsOf: [.comments(model: .init(
                        commentsModel: $0,
                        isNested: true,
                        nestedName: self?.nestedNameRelay.value ?? "",
                        nestedComment: self?.nestedCommentRelay.value ?? ""
                    ))])
                }
                
                guard let row = self?.selectedModelIndex.value?.row else { return }
                var currentArray = self?.sections.value
                currentArray?.insert(contentsOf: responseSections, at: row + 1)
                self?.sections.accept(currentArray ?? [])
            })
    }
    
    private func setupLibrariesCommentsObserbing() -> Disposable {
        service
            .getLibraryComments(requestData: LibraryCommentsRequestModel(library_id: model.id))
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                let model: [LibraryCommentsData] = response.data
                
                let containsComments = self.sections.value.contains { section in
                    if case .comments = section {
                        return true
                    }
                    return false
                }
                
                var currentSections = self.sections.value
                
                if !containsComments && !model.isEmpty {
                    currentSections.append(contentsOf: [.titleComments])
                }

                let models: [LibraryModelSectionType] = model.map {
                    .comments(model: .init(commentsModel: $0, isNested: false))
                }
                
                currentSections.append(contentsOf: models)
                self.sections.accept(currentSections)
            })
    }
    
    private func setupBackButtonObserbing(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe {  (`self`, _) in
                self.coordinator.route(to: .back)
            }
    }
    
    private func setupCommentTextObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: commentRelay)
    }
    
    private func setupMarkObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withLatestFrom(self.isSavedRelay.asObservable())
            .flatMapLatest { isSaved -> Observable<EmptyResponseModel> in
                self.isSavedRelay.accept(!isSaved)
                
                let id = self.model.id
                if isSaved {
                    return self.networkService
                        .removeFromSaved(requestData: .init(library_id: id))
                        .asObservable()
                        .catch { _ in .empty() }
                } else {
                    return self.networkService
                        .addToSaved(requestData: .init(library_id: id))
                        .asObservable()
                        .catch { _ in .empty() }
                }
            }
            .subscribe { _ in
                BookmarkService.shared.updateBookmark()
            }
    }
    
    private func setupDropDownDismissObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe {  (`self`, _) in
                self.moreSelectedRelay.accept(nil)
            }
    }
}
