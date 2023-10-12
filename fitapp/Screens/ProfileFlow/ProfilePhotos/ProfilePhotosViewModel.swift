//
//  ProfilePhotosViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

enum PublicationType: String {
    case picture = "PICTURE"
}

class ProfilePhotosViewModel: DeinitAnnouncerType {
    
    private var coordinator: ProfilePhotosCoordinator
    
    private let networkService = ServiceFactory.createNetworkService()
    
    private let reloadSubject = PublishSubject<Void>()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let photosRelay = BehaviorRelay<[PhotoModelUrl]>(value: [])
    
    private let canAddPhotosRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    private let profileType: ProfileType
    
    init(_ coordinator: ProfilePhotosCoordinator, type: ProfileType) {
        self.coordinator = coordinator
        self.profileType = type
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: ProfilePhotosCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension ProfilePhotosViewModel: ViewModelProtocol {
    
    struct Input {
        let photoSelected: Observable<UIImage>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let loading: Driver<Bool>
        let canAdd: Driver<Bool>
        let photos: BehaviorRelay<[PhotoModelUrl]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        canAddPhotosRelay.accept(profileType.isOwn)
        
        input.disposeBag.insert([
            setupPublicationsObserving(id: profileType.id, disposeBag: input.disposeBag),
            setupPhotoSelectedObserving(with: input.photoSelected),
        ])
        
        let output = Output(
            loading: isLoadingRelay.asDriver(onErrorJustReturn: false),
            canAdd: canAddPhotosRelay.asDriver(onErrorJustReturn: false),
            photos: photosRelay
        )
        
        outputHandler(output)
        reloadSubject.onNext(())
    }
    
    private func setupPublicationsObserving(id: String, disposeBag: DisposeBag) -> Disposable {
        return reloadSubject
            .withUnretained(self)
            .flatMap { (self, _) in
                self.isLoadingRelay.accept(true)
                let data = PageRequestData(limit: 100, page: 0)
                return self.networkService.getPublications(requestData: data, userId: id).asObservable()
            }
            .map { response -> [PhotoModelUrl] in
                response.data
                    .filter { $0.type == PublicationType.picture.rawValue }
                    .compactMap { $0.toPhotoModel() }
            }
            .withUnretained(self)
            .do(onNext: { (`self`, items) in
                items.forEach { model in
                    self.setupPhotoRemoveObserving(model: model, disposeBag: disposeBag)
                    self.setupPhotoLongPressObserving(currentModel: model, disposeBag: disposeBag)
                }
            })
            .subscribe { (`self`, items) in
                self.isLoadingRelay.accept(false)
                self.photosRelay.accept(items)
            }
    }
    
    private func setupPhotoSelectedObserving(with signal: Observable<UIImage>) -> Disposable {
        signal
            .compactMap { $0.compressToData(sizeInKb: 250) }
            .withUnretained(self)
            .flatMap { (self, data) in
                self.isLoadingRelay.accept(true)
                
                return self.networkService
                    .createPublication(requestData: .init(header: "test", picture: data))
            }
            .asObservable()
            .withUnretained(self)
            .subscribe { (self, response) in
                self.reloadSubject.onNext(())
            }
    }
    
    private func setupPhotoRemoveObserving(model: PhotoModelUrl, disposeBag: DisposeBag) {
        // TODO: -TN- Implement logic
        model.removePhotoSubject
//            .withUnretained(self)
//            .flatMap { (self, data) in
//                self.isLoadingRelay.accept(true)
//
//                return self.networkService
//                    .createPublication(requestData: .init(header: "test", picture: data))
//            }
//            .asObservable()
            .withUnretained(self)
            .subscribe { (self, _) in
                print("> T: REMOVE PHOTO with ID: \(model.uuid)")
                self.setupPublicationsObserving(id: self.profileType.id, disposeBag: disposeBag)
                    .disposed(by: disposeBag)

            }
            .disposed(by: disposeBag)
    }
    
    // NOTE: -TN- This method needs to hide RemoveButton on the rest of the photos
    private func setupPhotoLongPressObserving(currentModel: PhotoModelUrl, disposeBag: DisposeBag) {
        currentModel.longPressSubject
            .withUnretained(self)
            .subscribe { (`self`, _) in
                self.photosRelay.value.forEach { model in
                    model.removeEnabledSubject.onNext(model.uuid == currentModel.uuid)
                }
                print("> T: ReloadPhotos: \(currentModel.uuid)")
            }
            .disposed(by: disposeBag)
    }
}
