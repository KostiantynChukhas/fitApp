//
//  AnalyticsStatsViewModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import RxSwift
import RxCocoa

class AnalyticsStatsPeriod: Equatable, Codable {
    static func == (lhs: AnalyticsStatsPeriod, rhs: AnalyticsStatsPeriod) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    let description: String
    let image: String
    
    init(title: String, description: String, image: String) {
        self.title = title
        self.description = description
        self.image = image
    }
}

class AnalyticsStatsViewModel: DeinitAnnouncerType {
    
    private var coordinator: AnalyticsStatsCoordinator
    
    private let itemsPeriod = BehaviorRelay<[AnalyticsStatsPeriod]>(value: [])
    
    private var networkService = ServiceFactory.createNetworkService()
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: AnalyticsStatsCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
        
        itemsPeriod.accept([AnalyticsStatsPeriod(title: "2540", description: "Cal", image: "fireIcon"),
                            AnalyticsStatsPeriod(title: "34", description: "Km", image: "runIcon"),
                            AnalyticsStatsPeriod(title: "1023", description: "Kg", image: "kettlebellIcon")])
    }
    
    func route(to route: AnalyticsStatsCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension AnalyticsStatsViewModel: ViewModelProtocol {
    
    struct Input {
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let itemsPeriodObservable: Driver<[AnalyticsStatsPeriod]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
        ])
        
        let output = Output(
            itemsPeriodObservable: itemsPeriod.asDriver(onErrorJustReturn: []))
        
        outputHandler(output)
    }
    
   
}
