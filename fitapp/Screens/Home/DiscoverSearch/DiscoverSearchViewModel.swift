//
//  DiscoverSearchViewModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 05.07.2023.
//


import RxSwift
import RxCocoa

enum DiscoverSearchSectionType {
    case search
    case community(model: CommunityCellViewModel)
    case library
    case workouts
}

class DiscoverSearchViewModel: DeinitAnnouncerType {
    
    private var coordinator: DiscoverSearchCoordinator
    
    private let itemsRelay = BehaviorRelay<[DiscoverSearchSectionType]>(value: [])
    
    private var networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let nerworkService = ServiceFactory.createNetworkService()

    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: DiscoverSearchCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: DiscoverSearchCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension DiscoverSearchViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[DiscoverSearchSectionType]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupSectionsObservable()
        ])
        
        let output = Output(
            items: itemsRelay.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
    }
    
    private func setupSectionsObservable() -> Disposable {
        nerworkService
            .communityView(requestData: CommunityViewRequestModel(type_community_page: "news".uppercased(), search: nil))
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                let communityData: [CommunityViewData] = response.data

                let communityList: [CommunityCellViewModel] = communityData.compactMap { model in
                    return CommunityCellViewModel(model: model)
                }
                
                let sectionTypes: [DiscoverSearchSectionType] = communityList.map { .community(model: $0) }
                self.itemsRelay.accept(sectionTypes)
            })
    }
   
}
