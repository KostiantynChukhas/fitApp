//
//  OnboardingVM.swift//

import Foundation
import RxSwift
import RxCocoa

struct OnboardingDataItem {
    let title: String
    let subTitle: String
    let imageName: String
}

class OnboardingViewModel: DeinitAnnouncerType {
    private var coordinator: OnboardingCoordinator
    
    private var service = FitappNetworkService(baseURL: FitappURLs.getBaseURl(for: .release))
    
    private let collectionItemsViewModels = BehaviorRelay<[OnboardingData]>(value: [])
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let isSelectedIndex = BehaviorRelay<Int>(value: 0)
    
    private let isSelectedIndexFromScroll = BehaviorRelay<Int>(value: 0)

    private let nextTitleRelay =  BehaviorRelay<String>(value: "Next")

    init(_ coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: OnboardingCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension OnboardingViewModel: ViewModelProtocol {
    struct Input {
        let disposeBag: DisposeBag
        let tapNextButtonSignal: Observable<Void>
        let tapSkipButtonSignal: Observable<Void>
        let scrollOnboarding: Observable<Int>
    }
    
    struct Output {
        let collectionItemsObservable: Driver<[OnboardingData]>
        let selectedIndex: Driver<Int>
        let nextButtonTitle: Driver<String>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupItemsObserbing(),
            setupSkipButtonObserbing(with: input.tapSkipButtonSignal),
            setupNextObserving(with: input.tapNextButtonSignal),
            setupScrollObserving(with: input.scrollOnboarding)
        ])
        
        let output = Output(
            collectionItemsObservable: collectionItemsViewModels.asDriver(onErrorJustReturn: []),
            selectedIndex: isSelectedIndex.asDriver(onErrorJustReturn: 0).skip(1),
            nextButtonTitle: nextTitleRelay.asDriver(onErrorJustReturn: .empty)
        )
        outputHandler(output)
    }
    
    private func setupSkipButtonObserbing(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                self.coordinator.route(to: .onboardingWasShown)
            })
    }

    private func setupScrollObserving(with signal: Observable<Int>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] index in
                guard let itemsCount = self?.collectionItemsViewModels.value.count else { return }
                let isLast = index == itemsCount - 1
                let title = isLast ? "Start": "Next"
                
                self?.isSelectedIndex.accept(index)
                self?.nextTitleRelay.accept(title)
            })
    }
    
    private func setupNextObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, _) in
                let index = self.isSelectedIndex.value + 1

                let isLast = index == self.collectionItemsViewModels.value.count - 1
                let shouldFinish = index == self.collectionItemsViewModels.value.count
                let title = isLast ? "Start": "Next"
              
                if shouldFinish {
                    self.coordinator.route(to: .onboardingWasShown)
                } else {
                    self.isSelectedIndex.accept(index)
                }
                
                self.nextTitleRelay.accept(title)
            })
    }
    
    private func setupItemsObserbing() -> Disposable {
        service.onboarding(requestData: .init())
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                self.collectionItemsViewModels.accept(response.data)
            })
    }
}

