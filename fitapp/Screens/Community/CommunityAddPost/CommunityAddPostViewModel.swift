//
//  CommunityAddPostViewModel.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class CommunityAddPostViewModel: DeinitAnnouncerType {
    
    private var coordinator: CommunityAddPostCoordinator
    
    private let postTextRelay = BehaviorRelay<String>(value: .empty)

    private let viewAndCreateRelay: BehaviorRelay<Void> = .init(value: ())
    
    private let draftData: BehaviorRelay<DraftData?> = .init(value: nil)
    
    private let idCommunityRelay = BehaviorRelay<String>(value: .empty)
    
    private let imagesRelay = BehaviorRelay<[DraftModel]>(value: [])
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let networkService = ServiceFactory.createNetworkService()
    
    
    init(_ coordinator: CommunityAddPostCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: CommunityAddPostCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension CommunityAddPostViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
        let postText: Observable<String>
        let backSignal: Observable<Void>
        let postSignal: Observable<Void>
        let imageDataSignal: Observable<[Data]>
        let videoDataSignal: Observable<Data>
        let removeImageSignal: Observable<DraftModel>
    }
    
    struct Output {
        let draftData: Driver<DraftData?>
        let images: Driver<[DraftModel]>
        let isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            viewAndCreateDraftCommunity(),
            setupBackObserving(with: input.backSignal),
            setupPostObserving(with: input.postSignal),
            setupPostTextObserving(with: input.postText),
            sendImageMediaObserving(with: input.imageDataSignal),
            setupRemoveImageObserving(with: input.removeImageSignal)
        ])
        
        let output = Output(
            draftData: draftData.asDriver(onErrorJustReturn: nil),
            images: imagesRelay.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false)
        )
        
        outputHandler(output)
    }
    
    private func viewAndCreateDraftCommunity() -> Disposable {
        viewAndCreateRelay
            .withUnretained(self)
            .flatMap { (`self`, _) in
                self.isLoadingRelay.accept(true)
                return self.networkService.viewAndCreateDraftCommunity(requestData: .init()).asObservable()
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                guard let data = response.data else { return }
                self.draftData.accept(data)
                
                let images = data.files?.compactMap { DraftModel(id: UUID().uuidString, url: $0) } ?? []
                self.imagesRelay.accept(images)
                self.idCommunityRelay.accept(data.id ?? "")
            })
    }
    
    private func sendImageMediaObserving(with signal: Observable<[Data]>) -> Disposable {
        signal
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(true) })
            .withUnretained(self)
            .flatMap { (`self`, imageData) -> Observable<[DraftCommunityResponseModel]> in
                let observables = imageData.map {
                    let data = UploadDataDraftCommunityRequestModel(description: nil,
                        id_community: self.idCommunityRelay.value,
                        image: $0,
                        video: nil
                    )
                    
                    return self.networkService.uploadDataDraftCommunity(requestData: data).asObservable()
                        .catch { _ in .empty() }
                }
                
                return Observable.combineLatest(observables)
            }
            .flatMap { _ in
                return self.networkService.viewAndCreateDraftCommunity(requestData: .init())
                    .asObservable()
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                guard let data = response.data else { return }
                self.draftData.accept(data)
                
                let images = data.files?.compactMap { DraftModel(id: UUID().uuidString, url: $0) } ?? []
                self.imagesRelay.accept(images)
                self.idCommunityRelay.accept(data.id ?? "")
            })
    }
    
    private func setupPostTextObserving(with signal: Observable<String>) -> Disposable {
        _ = signal.bind(to: postTextRelay)
        
        return signal
            .withUnretained(self)
            .flatMap { (`self`, _) in
                let newData = UploadDataDraftCommunityRequestModel(description: self.postTextRelay.value, id_community: self.idCommunityRelay.value, image: nil, video: nil)
                return self.networkService.uploadDataDraftCommunity(requestData: newData)
                    .asObservable()
            }
            .withUnretained(self)
            .subscribe()
    }
    
    private func setupBackObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                self.route(to: .back)
            })
    }
    
    private func setupPostObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { (`self`, _) in
                self.isLoadingRelay.accept(true)
                let data = CommunityRequestModel(id_community: self.idCommunityRelay.value)
                return self.networkService.createCommunityPost(requestData: data).asObservable()
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, _) in
                self.route(to: .back)
            })
    }
    
    private func setupRemoveImageObserving(with signal: Observable<DraftModel>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { (self, model) in
                var images = self.imagesRelay.value
                images.removeAll(where: { $0.url == model.url })
                self.imagesRelay.accept(images)
                
                let id = self.idCommunityRelay.value
                let data = RemoveDraftFileRequestData(id_community: id, file_url: model.url)
                return self.networkService.removeDraftFile(requestData: data)
                    .asObservable()
                    .catch { _ in .empty() }
            }
            .asObservable()
            .withUnretained(self)
            .subscribe()
    }
}
