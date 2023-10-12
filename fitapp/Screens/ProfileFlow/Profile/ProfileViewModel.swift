//
//  ProfileViewModel.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: DeinitAnnouncerType {
    
    private var coordinator: ProfileCoordinator
    private var disposeBag = DisposeBag()

    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    private let topSegmentViewModel: TopSegmentViewModel
    
    private let mainSegmentViewModel: MainSegmentViewModel
    
    private let profileTypeRelay = PublishRelay<ProfileType>()
    
    private let privateUserRelay = BehaviorRelay<Bool>(value: false)
    
    private let type: ProfileType

    init(
        _ coordinator: ProfileCoordinator,
        topSegmentViewModel: TopSegmentViewModel,
        mainSegmentViewModel: MainSegmentViewModel,
        type: ProfileType
    ) {
        self.coordinator = coordinator
        self.topSegmentViewModel = topSegmentViewModel
        self.mainSegmentViewModel = mainSegmentViewModel
        self.type = type
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: ProfileCoordinator.Route) {
        coordinator.route(to: route)
    }
    
    func reload(userData: UserData) {
        switch self.type {
        case .ownProfile:
            self.profileTypeRelay.accept(.ownProfile(model: userData))
        default:
            return
        }
    }
}

// MARK: - ViewModelProtocol

extension ProfileViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
        let rightButtonSignal: Observable<Void>
        let leftButtonSignal: Observable<Void>
        let uploadImageSignal: Observable<Data>
        let profileInfo: ProfileInfoView.Output
    }
    
    struct Output {
        let topSegmentViewModel: Observable<TopSegmentViewModel>
        let mainSegmentViewModel: Observable<MainSegmentViewModel>
        let type: Observable<ProfileType>
        let `private`: Observable<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupRightButtonObserving(with: input.rightButtonSignal),
            setupLeftButtonObserving(with: input.leftButtonSignal),
        ])
        
        if type.isOwn {
            input.disposeBag.insert([
                setupProfileImageObserving(with: input.uploadImageSignal),
                setupUserInfoObserbing(),
                setupUserInfoChangedObserving()
            ])
        }
        
        let output = Output(
            topSegmentViewModel: .just(topSegmentViewModel),
            mainSegmentViewModel: .just(mainSegmentViewModel),
            type: profileTypeRelay.asObservable(),
            private: privateUserRelay.asObservable()
        )
        
        outputHandler(output)
        
        self.profileTypeRelay.accept(type)
    }
    
    private func setupRightButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            guard let self = self else { return }
            
            switch self.type {
            case .trainer:
                self.route(to: .messages)
            case .ownProfile(let user):
                self.route(to: .editProfile(avatar: user.avatar ?? ""))
            case .userProfile:
                break
            }
        }
    }
    
    private func setupLeftButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            guard let self = self else { return }
            
            switch self.type {
            case .trainer, .userProfile:
                self.route(to: .back)
            case .ownProfile:
                self.route(to: .settings)
            }
        }
    }
    
    private func setupProfileImageObserving(with signal: Observable<Data>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { (`self`, dataImage) in
                let profileImageModel = UploadProfileImageRequestModel(picture: dataImage)
                return self.nerworkService.updateProfileImage(requestData: profileImageModel)
            }
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                guard let data = response.data else { return }
                SessionManager.shared.setUser(user: data)
            })
    }
    
    private func setupUserInfoObserbing() -> Disposable {
        nerworkService.getProfileInfo(requestData: .init())
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                guard let userData = response.data else { return }
                SessionManager.shared.setUser(user: userData)
            })
    }
    
    private func setupUserInfoChangedObserving() -> Disposable {
        SessionManager.shared.userInfoChangedObserver.asObserver()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.profileTypeRelay.accept(.ownProfile(model: $0))
            })
    }
    
    private func setupBookmarksUpdatedObserving() -> Disposable {
        BookmarkService.shared.bookmarkUpdated
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                self.setupUserInfoObserbing()
                    .disposed(by: self.disposeBag)
            })
    }
}
