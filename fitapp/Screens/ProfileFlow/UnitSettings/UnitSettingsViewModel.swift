//
//  UnitSettingsViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class UnitSettingsViewModel: DeinitAnnouncerType {
    
    private var coordinator: UnitSettingsCoordinator
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    private let itemsRelay = BehaviorRelay<[UnitSettingCellViewModel]>(value: [])
    
    private let weightModel: UnitSettingCellViewModel
    
    private let heightModel: UnitSettingCellViewModel
    
    init(_ coordinator: UnitSettingsCoordinator) {
        self.coordinator = coordinator
        
        let type: UnitSystemType = SessionManager.shared.user?.typeMetricSystem?.lowercased() == "eu" ? .eu: .usa
        self.weightModel = .init(unitType: .weight, selectedSystemType: type, isEditable: true)
        self.heightModel = .init(unitType: .height, selectedSystemType: type, isEditable: false)
        
        itemsRelay.accept([weightModel, heightModel])
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: UnitSettingsCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension UnitSettingsViewModel: ViewModelProtocol {
    
    struct Input {
        let backSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[UnitSettingCellViewModel]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackObserving(with: input.backSignal),
            setupUnitChangedObserving()
        ])
        
        let output = Output(
            items: itemsRelay.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
    }
    
    private func setupBackObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.coordinator.route(to: .back)
        }
    }
    
    private func setupUnitChangedObserving() -> Disposable {
        weightModel.didSelectType
            .flatMap { type in
                self.heightModel.didSelectType.onNext(type)
                return self.nerworkService
                    .updateOnboardingInfo(requestData: OnboardingInfoRequestModel(type_metric_system: type.rawValue.uppercased()))
                    .asObservable()
            }
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                SessionManager.shared.user?.typeMetricSystem = response.data?.typeMetricSystem
            })
    }
    
}
