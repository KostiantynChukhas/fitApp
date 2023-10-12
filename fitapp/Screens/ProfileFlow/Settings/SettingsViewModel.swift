//
//  SettingsViewModel.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import Foundation
import RxSwift
import RxCocoa
import StoreKit

class SettingsViewModel: DeinitAnnouncerType {
    
    private var coordinator: SettingsCoordinator
    
    private let publicProfileModel: SwitcherCellModel
    
    private let displayMeasurementsModel: SwitcherCellModel
    
    private let workoutReminderModel: SwitcherCellModel
    
    private let commentsModel: SwitcherCellModel
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let itemsRelay = BehaviorRelay<[SettingType]>(value: [])
    
    private let nerworkService = ServiceFactory.createNetworkService()
        
    init(_ coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
        
        self.publicProfileModel = .init(
            type: .publicProfile,
            isSelected: SessionManager.shared.user?.typeAccount == .publicAccount
        )
        self.displayMeasurementsModel = .init(type: .displayMeasurements, isSelected: false)
        self.workoutReminderModel = .init(type: .workoutReminder, isSelected:  SessionManager.shared.user?.notificationWorkout ?? false)
        self.commentsModel = .init(type: .comments, isSelected:  SessionManager.shared.user?.notificationComments ?? false)
        
        self.initSections()
        self.setupDeinitAnnouncer()
    }
    
    private func initSections() {
        var items: [SettingType] = []
        
        items.append(.header(title: "Units"))
        items.append(.default(model: .init(type: .setUnit)))
        items.append(.spacer)
        items.append(.header(title: "Privacy"))
        items.append(.switcher(model: publicProfileModel))
        items.append(.switcher(model: displayMeasurementsModel))
        items.append(.spacer)
        items.append(.header(title: "Notifications"))
        items.append(.switcher(model: workoutReminderModel))
        items.append(.switcher(model: commentsModel))
        items.append(.spacer)
        items.append(.header(title: "Support"))
        items.append(.default(model: .init(type: .contactUs)))
        items.append(.spacer)
        items.append(.header(title: "Other"))
        items.append(.default(model: .init(type: .rateTheApp)))
        items.append(.default(model: .init(type: .termsOfUse)))
        items.append(.default(model: .init(type: .privacyPolicy)))
        items.append(.spacer)
        items.append(.action(model: .init(action: .logOut)))
        items.append(.action(model: .init(action: .deleteAccount)))
        
        itemsRelay.accept(items)
    }
    
    
    func route(to route: SettingsCoordinator.Route) {
        coordinator.route(to: route)
    }
    
}

// MARK: - ViewModelProtocol

extension SettingsViewModel: ViewModelProtocol {
    
    struct Input {
        let backSignal: Observable<Void>
        let modelSelected: Observable<SettingType>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[SettingType]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackObserving(with: input.backSignal),
            setupModelSelectedObserving(with: input.modelSelected),
            
            setupUpdateTypeAccountObserving(with: publicProfileModel.valueChangedObserver),
            setupUpdateWorkoutObserving(with: workoutReminderModel.valueChangedObserver),
            setupCommentsObserving(with: commentsModel.valueChangedObserver)
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
    
    private func setupModelSelectedObserving(with signal: Observable<SettingType>) -> Disposable {
        signal.bind { [weak self] in
            switch $0 {
            case .action(let model):
                switch model.action {
                case .deleteAccount:
                    self?.coordinator.route(to: .deleteAccount)
                case .logOut:
                    self?.coordinator.route(to: .logout)
                }
            case .switcher(let model):
                switch model.type {
                case .publicProfile:
                    break
                case .displayMeasurements:
                    break
                case .workoutReminder:
                    break
                case .comments:
                    break
                }
            case .default(let model):
                switch model.type {
                case .setUnit:
                    self?.coordinator.route(to: .setUnits)
                case .rateTheApp:
                    if #available(iOS 10.3, *) {
                        SKStoreReviewController.requestReview()
                    }
                default: return
                }
                
            default:
                return
            }
        }
    }
    
    private func setupUpdateTypeAccountObserving(with signal: Observable<Bool>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMapLatest { (`self`, value) in
                self.nerworkService
                    .updateProfileInfo(requestData: .init(type_account: value ? "PUBLIC": "PRIVATE"))
                    .asObservable()
            }
            .withUnretained(self)
            .subscribe { (`self`, response) in
                guard let data = response.data else { return }
                SessionManager.shared.user?.typeAccount = data.typeAccount
            }
    }
    
    private func setupCommentsObserving(with signal: Observable<Bool>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMapLatest { (`self`, value) in
                self.nerworkService.updateProfileInfo(requestData: .init(notification_comments: value)).asObservable()
            }
            .withUnretained(self)
            .subscribe { (`self`, response) in
                guard let data = response.data else { return }
                SessionManager.shared.user?.notificationComments = data.notificationComments
            }
    }
    
    private func setupUpdateWorkoutObserving(with signal: Observable<Bool>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMapLatest { (`self`, value) in
                self.nerworkService.updateProfileInfo(requestData: .init(notification_workout: value)).asObservable()
            }
            .withUnretained(self)
            .subscribe { (`self`, response) in
                guard let data = response.data else { return }
                SessionManager.shared.user?.notificationWorkout = data.notificationWorkout
            }
    }
}



