//
// 
//  HomeTabBarViewModel.swift
//  
//
//  Created by  MacBook Pro 16 on 27/02/23.
//  Copyright © 2023 Nikola Milic. All rights reserved.
//
//  

import Foundation
import RxSwift
import RxCocoa

final class HomeTabBarViewModel: DeinitAnnouncerType {
    
    // MARK: - Injections
    
    struct Injections {
        let tabs: [TabBarType]
        let defaultSelectedTab: TabBarType
    }
    
    let dismissEvent: PublishSubject<Void> = .init()
    let tabTypeTapEvent: PublishSubject<TabBarType> = .init()
    let selectedTabType: PublishSubject<TabBarType> = .init()
    let refreshTabEvent: PublishSubject<TabBarType> = .init()
    let animateTabTypeEvent: PublishSubject<TabBarType> = .init()
    
    private let selectTabType: PublishSubject<TabBarType> = .init()
    
    private var postOnboardingDataDisposable: Disposable?

    init(injections: Injections) {
    
    }
}

// MARK: - ViewModelProtocol

extension HomeTabBarViewModel: ViewModelProtocol {
    
    struct Input {
        let tabTypeTapEvent: Observable<TabBarType>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let selectTabType: Driver<TabBarType>
    }
    
    // MARK: - Transform
    
    func transform(_ input: Input, outputHandler: @escaping (_ output: Output) -> Void) {
        
        input.disposeBag.insert([
            input.tabTypeTapEvent.bind(to: tabTypeTapEvent)
        ])
        
        input.disposeBag.insert([
          setupSelectedTabObserving(),
          setupTabTypeAnimationObserving()
        ])
        
        let output = Output(
            selectTabType: selectTabType.asDriverOnErrorJustComplete()
        )
        
        outputHandler(output)
    }
    
    private func setupSelectedTabObserving() -> Disposable {
        tabTypeTapEvent
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tabType in
                self?.update(tabType: tabType)
            })
    }
    
    private func setupTabTypeAnimationObserving() -> Disposable {
        animateTabTypeEvent
            .subscribe(onNext: { [weak self] tabType in
                
            })
    }
    
}

extension HomeTabBarViewModel {
    
    private func update(tabType: TabBarType) {
        selectTabType.onNext(tabType)
    }
    
    private func refresh(tabType: TabBarType) {
        refreshTabEvent.onNext(tabType)
    }
    
}
