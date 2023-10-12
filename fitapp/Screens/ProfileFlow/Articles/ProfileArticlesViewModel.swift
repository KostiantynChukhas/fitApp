//
//  ProfileArticlesViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileArticlesViewModel: DeinitAnnouncerType {
    
    private var coordinator: ProfileArticlesCoordinator
    private var disposeBag = DisposeBag()

    private let items = BehaviorRelay<[LibraryList]>(value: [])
    
    private let data = BehaviorRelay<[LibraryData]>(value: [])
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: ProfileArticlesCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: ProfileArticlesCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension ProfileArticlesViewModel: ViewModelProtocol {
    
    struct Input {
        let modelSelected: Observable<LibraryList>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[LibraryList]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
           setupArticlesObserving(),
           setupBookmarksUpdatedObserving(),
           setupModelSelectedObserving(with: input.modelSelected)
        ])
        
        let output = Output(
            items: items.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
    }
    
    private func setupArticlesObserving() -> Disposable {
        nerworkService.getArticles(requestData: .init(limit: 100, page: 0))
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                let libraryData: [LibraryData] = response.data
                let libraryList: [LibraryList] = libraryData.compactMap { model in
                    .init(title: model.header, img: model.picture, id: model.id)
                }
                self.data.accept(libraryData)
                self.items.accept(libraryList)
            })
    }
    
    private func setupModelSelectedObserving(with signal: Observable<LibraryList>) -> Disposable {
        signal.bind { [weak self] item in
            guard let model = self?.data.value.first(where: {  $0.id == item.id }) else { return }
            self?.coordinator.route(to: .article(model: model))
        }
    }
    
    private func setupBookmarksUpdatedObserving() -> Disposable {
        BookmarkService.shared.bookmarkUpdated
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                self.setupArticlesObserving()
                    .disposed(by: self.disposeBag)
            })
        }
    }

