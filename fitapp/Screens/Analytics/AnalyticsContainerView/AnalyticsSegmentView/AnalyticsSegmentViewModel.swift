//
//  AnalyticsSegmentViewModel.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//
import UIKit
import RxSwift
import RxCocoa

struct AnalyticsSegmentViewModel: ViewModelProtocol {
    internal struct Input {
        let willDisplayScreenByIndex: Observable<Int>
        let didEndDisplayingScreenByIndex: Observable<Int>
        let didEndDeceleratingByIndex: Observable<Int>
        let didEndScrollToItem: Observable<Int>
        let analyticsSegmentUpdated: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    internal struct Output {
        let dataSource: Driver<[UIViewController]>
        let indexPathSelectedObserver: Observable<(indexPath: IndexPath, animated: Bool)>
        let initialIndexPathSelectedObserver: Observable<(indexPath: IndexPath, animated: Bool)>
    }
    
    internal struct Signals {
        let setInitialIndex: Publisher<Int> = .init()
        let indexSelected: Publisher<(row: Int, animated: Bool)> = .init()
        let willDisplayScreenByIndex: Publisher<Int> = .init()
        let didEndDisplayingScreenByIndex: Publisher<Int> = .init()
        let didEndDeceleratingByIndex: Publisher<Int> = .init()
        let didEndScrollToItem: Publisher<Int> = .init()
        let analyticsSegmentUpdated: Publisher<Void> = .init()
    }
    
    let signals: Signals = .init()
    
    private let dataSource: [UIViewController]
    
    init(dataSource: [UIViewController]) {
        self.dataSource = dataSource
    }

    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            input.willDisplayScreenByIndex.asObservable().bind(to: signals.willDisplayScreenByIndex),
            input.didEndDisplayingScreenByIndex.asObservable().bind(to: signals.didEndDisplayingScreenByIndex),
            input.didEndDeceleratingByIndex.asObservable().bind(to: signals.didEndDeceleratingByIndex),
            input.didEndScrollToItem.asObservable().bind(to: signals.didEndScrollToItem),
            input.analyticsSegmentUpdated.asObservable().bind(to: signals.analyticsSegmentUpdated)
        ])
        
            let indexPathSelectedObserver = signals.indexSelected.asObservable()
            .map{ (indexPath: IndexPath(row: $0.row), animated: $0.animated) }
            let initialIndexPathSelectedObserver = signals.setInitialIndex.asObservable()
                .map{ (indexPath: IndexPath(row: $0), animated: false) }
        
        let output = Output(dataSource: .just(dataSource),
                            indexPathSelectedObserver: indexPathSelectedObserver,
                            initialIndexPathSelectedObserver: initialIndexPathSelectedObserver)
        outputHandler(output)
    }
}
