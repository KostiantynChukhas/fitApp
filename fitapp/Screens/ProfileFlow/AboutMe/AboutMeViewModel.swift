//
//  AboutMeViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class AboutMeViewModel: DeinitAnnouncerType {
    
    private var coordinator: AboutMeCoordinator
    
    private let networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    private let itemsRelay = BehaviorRelay<[AboutMeCellViewModel]>(value: [])
    
    private let type: ProfileType
    
    init(_ coordinator: AboutMeCoordinator, type: ProfileType) {
        self.coordinator = coordinator
        self.type = type
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: AboutMeCoordinator.Route) {
        coordinator.route(to: route)
    }
    
    private func configureItems(user: UserData) {
        var items: [AboutMeCellViewModel] = []
        
        if let country = user.country, !country.isEmpty {
            items.append(.init(type: .country, text: country))
        }
        
        if let city = user.city, !city.isEmpty {
            items.append(.init(type: .city, text: city))
        }
        
        if let gym = user.gym, !gym.isEmpty {
            items.append(.init(type: .gym, text: gym))
        }
        
        if let experience = user.experience, !experience.isEmpty {
            items.append(.init(type: .experience, text: experience))
        }
        
        if let myGoal = user.myGoal, !myGoal.isEmpty {
            items.append(.init(type: .myGoal, text: myGoal))
        }
        
        if let shortStory = user.shortStory, !shortStory.isEmpty {
            items.append(.init(type: .shortStory, text: shortStory))
        }
        
        itemsRelay.accept(items)
    }
    
    private func configureItems(user: TrainerData) {
        var items: [AboutMeCellViewModel] = []
        
        items.append(.init(type: .aboutMe, text: user.aboutMe))
        items.append(.init(type: .achievements, text: user.achievements))
        items.append(.init(type: .experience, text: user.experience))
        items.append(.init(type: .education, text: user.education))
        items.append(.init(type: .other, text: user.other))
        
        itemsRelay.accept(items)
    }
    
}

// MARK: - ViewModelProtocol

extension AboutMeViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[AboutMeCellViewModel]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        switch self.type {
        case .ownProfile(let user):
            input.disposeBag.insert([
                setupUserInfoObserving(user: user),
                setupUserInfoChangedObserving()
            ])
        case .userProfile(let user):
            self.configureItems(user: user)
        case .trainer(let trainer):
            self.configureItems(user: trainer)
        }
        
        let output = Output(
            items: itemsRelay.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
    }
    
    private func setupUserInfoObserving(user: UserData) -> Disposable {
        isLoadingRelay.accept(true)
        
        return networkService.getProfileInfo(requestData: .init(), id: user.id)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                guard let user = response.data else { return }
                self.configureItems(user: user)
                self.isLoadingRelay.accept(false)
            })
    }
    
    private func setupUserInfoChangedObserving() -> Disposable {
        SessionManager.shared.userInfoChangedObserver.asObserver()
            .subscribe(onNext: { [weak self] in
                self?.configureItems(user: $0)
            })
    }
}
