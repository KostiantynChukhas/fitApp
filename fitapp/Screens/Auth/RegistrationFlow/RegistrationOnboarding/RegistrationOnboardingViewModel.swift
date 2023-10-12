//
//  RegistrationOnboardingViewModel.swift
//  fitapp
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationOnboardingViewModel: DeinitAnnouncerType {
    
    private let coordinator: RegistrationOnboardingCoordinator
    
    private var service = FitappNetworkService(baseURL: FitappURLs.getBaseURl(for: .release))
    
    private let sections = BehaviorRelay<[ExploreSectionModel]>(value: [])
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let isShowBackButton = BehaviorRelay<Bool>(value: false)
    
    private let isSelectedIndex = BehaviorRelay<Int>(value: 0)
    
    private let nextTitleRelay = BehaviorRelay<String>(value: "Next")
    
    private let errorValidateRelay = BehaviorRelay<String>(value: .empty)
    
    private let sendOnboardingModelRelay = PublishSubject<Void>()

    private let nerworkService = ServiceFactory.createNetworkService()
    
    //MARK: - Properties
    
    private var user: UserData
    
    private let tellUsModel: TellUsCellViewModel
    
    private let areasMostAttentionModel: TellAboutYourselfCellViewModel
    
    private let whatMotivatesModel: WhatMotivatesCellViewModel
    
    private let whatsYourNameModel: WhatsYourNameCellViewModel

    private let watsYourBirthModel: WatsYourBirthCellViewModel

    private let watsYourCurrentWeightModel: WatsYourCurrentWeightCellViewModel
    
    private let watsGoalWeightModel: WatsYourCurrentWeightCellViewModel
    
    private let watsHeightModel: WatsYourCurrentWeightCellViewModel
    
    private let whatActivityLevel: WhatMotivatesCellViewModel
    
    init(_ coordinator: RegistrationOnboardingCoordinator, user: UserData) {
        self.coordinator = coordinator
        self.user = user
        
        let gender = Gender(rawValue: user.gender?.lowercased() ?? "")
        self.tellUsModel = .init(gender: gender ?? .male)
        self.areasMostAttentionModel = .init(type: user.areasAttention?.compactMap { BodyType(rawValue: $0)} ?? [], gender: gender ?? .male)
        
        self.whatMotivatesModel = .init(
            cellType: .motivates, type: TypeMotivatesMost(rawValue: user.motivatesMost ?? "") ?? .none, typeActivity: .none )
        
        self.whatsYourNameModel = .init(name: user.name ?? "")
        self.watsYourBirthModel = .init(birth: user.dateBirth ?? "")
        
        self.watsYourCurrentWeightModel = .init(
            type: TypeMetricSystem(rawValue: user.typeMetricSystem ?? "") ?? .Eu,
            typeCells: .currentWeight,
            user: user
        )
        
        self.watsGoalWeightModel = .init(
            type: TypeMetricSystem(rawValue: user.typeMetricSystem ?? "") ?? .Eu,
            typeCells: .goalWeight,
            user: user
        )
        
        self.watsHeightModel = .init(
            type: TypeMetricSystem(rawValue: user.typeMetricSystem ?? "") ?? .Eu,
            typeCells: .currentHeight,
            user: user
        )
        
        self.whatActivityLevel = .init(
            cellType: .activity, type: .none, typeActivity: TypeActivityLevel(rawValue: user.activityLevel ?? "") ?? .none )
        
        setupDeinitAnnouncer()
    }
    
    func route(to route: RegistrationOnboardingCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension RegistrationOnboardingViewModel: ViewModelProtocol {
    struct Input {
        let disposeBag: DisposeBag
        let tapNextButtonSignal: Observable<Void>
        let tapBackButtonSignal: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<[ExploreSectionModel]>
        let selectedIndex: Driver<Int>
        let nextButtonTitle: Driver<String>
        let errorValidate: Driver<String>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackButtonObserbing(with: input.tapBackButtonSignal),
            setupNextObserving(with: input.tapNextButtonSignal),
            setupMetricSelected(),
            sendOnboardingDataObserving()
        ])
        
        let output = Output(
            sections: sections.asDriver(onErrorJustReturn: []),
            selectedIndex: isSelectedIndex.asDriver(onErrorJustReturn: 0).skip(1),
            nextButtonTitle: nextTitleRelay.asDriver(onErrorJustReturn: .empty),
            errorValidate: errorValidateRelay.asDriver(onErrorJustReturn: .empty)
        )
        outputHandler(output)
        setupSections()
    }
    
    private func setupSections() {
        let initialValue: [ExploreSectionModel] = [
            .tellUs(items: [.tellUs(model: self.tellUsModel)]),
            .tellAboutYourself(items: [.tellAboutYourself(model: self.areasMostAttentionModel)]),
            .whatMotivates(items: [.whatMotivates(model: self.whatMotivatesModel)]),
            .whatsYourName(items: [.whatsYourName(model: self.whatsYourNameModel)]),
            .whatsYourBirth(items: [.whatsYourBirth(model: self.watsYourBirthModel)]),
            .whatsYourCurrentWeight(items: [.whatsYourCurrentWeight(model: self.watsYourCurrentWeightModel)]),
            .whatsYourCurrentWeight(items: [.whatsYourCurrentWeight(model: self.watsGoalWeightModel)]),
            .whatsYourCurrentWeight(items: [.whatsYourCurrentWeight(model: self.watsHeightModel)]),
            .whatMotivates(items: [.whatMotivates(model: self.whatActivityLevel)])

        ]
        
        self.sections.accept(initialValue)
    }
    
    private func setupBackButtonObserbing(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                let index = self.isSelectedIndex.value - 1
                let isShowBack = index != 0 && index < 0
                
                self.isShowBackButton.accept(isShowBack)
                guard index >= 0, index < self.sections.value.count else { return }
                self.isSelectedIndex.accept(index)
                self.setupSections()
            })
    }
    
    private func setupMetricSelected() -> Disposable {
        watsYourCurrentWeightModel.typeObservable.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, type) in
                self.watsYourCurrentWeightModel.type = type
                self.watsHeightModel.type = type
                self.watsGoalWeightModel.type = type
                self.setupSections()
            })
    }
    
    private func setupNextObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                let currentIndex = self.isSelectedIndex.value
                
                var isEmpty = false
                var text = ""
                
                switch currentIndex {
                case 0:
                    self.areasMostAttentionModel.gender = self.tellUsModel.gender
                case 1:
                    isEmpty = self.areasMostAttentionModel.type.isEmpty
                    text = "Areas not selected, please make your choice!"
                case 2:
                    isEmpty = self.whatMotivatesModel.type == .none
                    text = "Motivates not chosen, make your choice!"
                case 3:
                    isEmpty = self.whatsYourNameModel.name.isEmpty
                    text = "Please enter your name!"
                case 4:
                    isEmpty = self.watsYourBirthModel.birth.isEmpty
                    text = "Please enter your date of birth!"
                case 5:
                    isEmpty = self.watsYourCurrentWeightModel.weight == .zero
                    text = "Please enter your weight!"
                case 6:
                    isEmpty = self.watsGoalWeightModel.goalWeight == .zero
                    text = "Please enter your goal weight!"
                case 7:
                    isEmpty = self.watsHeightModel.height == .zero
                    text = "Please enter your height!"
                case 8:
                    isEmpty = self.whatActivityLevel.typeActivity == .none
                    text = "Choose your current activity level!"
                default:
                    break
                }
                
                if isEmpty {
                    self.errorValidateRelay.accept(text)
                    return
                }
                
                let index = self.isSelectedIndex.value + 1
                let isLast = index == self.sections.value.count - 1
                let shouldFinish = index == self.sections.value.count 
                let title = isLast ? "Let’s start!": "Next"
                
                if shouldFinish {
                    self.sendOnboardingModelRelay.onNext(())
                } else {
                    self.isSelectedIndex.accept(index)
                }
                
                self.nextTitleRelay.accept(title)
                self.setupSections()
            })
    }
    
    private func sendOnboardingDataObserving() -> Disposable {
        sendOnboardingModelRelay
            .withUnretained(self)
            .flatMap { (`self`, _) in
                let onboardingInfoRequestModel = OnboardingInfoRequestModel(
                    gender: self.areasMostAttentionModel.gender.rawValue.uppercased(),
                    motivates_most: self.whatMotivatesModel.type.rawValue,
                    areas_attention: self.areasMostAttentionModel.type.map { $0.rawValue },
                    activity_level: self.whatActivityLevel.typeActivity.rawValue,
                    type_metric_system: self.watsYourCurrentWeightModel.type.rawValue,
                    weight: self.watsYourCurrentWeightModel.weight,
                    height: self.watsHeightModel.height,
                    date_birth: Double(self.watsYourBirthModel.birth) ?? 0,
                    goal_weight: self.watsGoalWeightModel.goalWeight
                )

                return self.nerworkService.updateOnboardingInfo(requestData: onboardingInfoRequestModel)
                    .asObservable()
                    .catchError { [weak self] error in
                        AlertManager.showFitAppAlert(title: "Sorry, some error at our side!", msg: error.localizedDescription, actionHandler: { [weak self] in
                            self?.coordinator.route(to: .login)
                        })
                        
                        return .empty()
                    }
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                guard let data = response.data else { return }
                self.coordinator.route(to: .onboardingWasShown)
            })
    }
}
