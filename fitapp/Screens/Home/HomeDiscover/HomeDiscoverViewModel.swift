//
//  HomeDiscoverViewModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import RxSwift
import RxCocoa

class HomeDiscoverViewModel: DeinitAnnouncerType {
    
    private var coordinator: HomeDiscoverCoordinator
    
    private var tagsRelay = BehaviorRelay<[TagCategoryModel]>(value: [])
    
    private var myWorkoutsRelay = BehaviorRelay<[String]>(value: [""])
    
    private var workoutsRelay = BehaviorRelay<[String]>(value: ["","","",""])
    
    private var helpfullRelay = BehaviorRelay<[String]>(value: ["","","","","","","",""])
    
    private var networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: HomeDiscoverCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: HomeDiscoverCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension HomeDiscoverViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
        let filteredButtonSignal: Observable<Void>
        let selectableTags: Observable<[TagCategoryModel]>
        let startSearchBarSignal: Observable<Void>
    }
    
    struct Output {
        let tagsObservable: Driver<[TagCategoryModel]>
        let myWorkoutsObservable: Driver<[String]>
        let workoutsObservable: Driver<[String]>
        let helpfullObservable: Driver<[String]>

    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupFilterTapButtonObserving(with: input.filteredButtonSignal),
            setupSectionsObservable(with: input.selectableTags),
            setupSearchTapButtonObserving(with: input.startSearchBarSignal)
        ])
        
        let output = Output(
            tagsObservable: tagsRelay.asDriver(onErrorJustReturn: []),
            myWorkoutsObservable: myWorkoutsRelay.asDriver(onErrorJustReturn: []),
            workoutsObservable: workoutsRelay.asDriver(onErrorJustReturn: []),
            helpfullObservable: helpfullRelay.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
    }
    
    private func setupSectionsObservable(with signal: Observable<[TagCategoryModel]>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] tags in
                self?.tagsRelay.accept(tags)
                let categories = tags.map({"\($0.id)"}).joined(separator: ",")
            })
    }
    
    
    private func setupFilterTapButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.route(to: .categories)
        }
    }
    
    private func setupSearchTapButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.route(to: .searchDiscover)
        }
    }
   
}
