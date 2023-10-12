//
//  TopSegmentViewModel.swift
//  fitapp
//
//  Created by on 25.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol TopSegmentCollectionViewModelProtocol {
    var title: String { get }
    var isActive: BehaviorRelay<Bool> { get }
}

final class TopSegmentCollectionViewModel: TopSegmentCollectionViewModelProtocol {
    private let type: SegmentItemType

    var title: String { return type.title }
    let isActive: BehaviorRelay<Bool>
    
    init(type: SegmentItemType, isActive: Bool) {
        self.type = type
        self.isActive = .init(value: isActive)
    }
}

final class TopSegmentViewModel: ViewModelProtocol {
    internal struct Input {
        let itemSelected: Observable<(indexPath: IndexPath, animated: Bool)>
        let disposeBag: DisposeBag
    }
    
    internal struct Output {
        let dataSource: Driver<[TopSegmentCollectionViewModelProtocol]>
        let invalidateLayoutObserver: Observable<Void>
        let indexSelectedObserver: Observable<Int>
        let setInitialIndex: Observable<Int>
    }
    
    internal struct Signals {
        let setInitialIndex: Publisher<Int> = .init()
        let indexSelected: Publisher<(row: Int, animated: Bool)> = .init()
        let invalidateLayout: Publisher<Void> = .init()
        let goToIndex: Publisher<Int> = .init()
    }
    
    let signals: Signals = .init()
    
    private let dataSource: [TopSegmentCollectionViewModelProtocol]

    init(dataSource: [TopSegmentCollectionViewModelProtocol]) {
        self.dataSource = dataSource
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        let dataSourceObservable = Observable.just(dataSource)
        
        let setInitialIndex = signals.setInitialIndex.asObservable()
        let indexSelected = signals.indexSelected.asObservable()
        let goToIndex = signals.goToIndex.asObservable()

        let mergeSelectedObeservables = Observable.merge([goToIndex,
                                                          indexSelected.map{ $0.row },
                                                          setInitialIndex])
        
        input.disposeBag.insert([
            setupItemSelected(with: input.itemSelected),
            setupIndexSelected(with: mergeSelectedObeservables, dataSource: dataSourceObservable)
        ])
        
        let output = Output(dataSource: dataSourceObservable.asDriver(onErrorJustReturn: []),
                            invalidateLayoutObserver: signals.invalidateLayout.asObservable(),
                            indexSelectedObserver: mergeSelectedObeservables,
                            setInitialIndex: setInitialIndex)
        outputHandler(output)
    }
    
    private func setupItemSelected(with signal: Observable<(indexPath: IndexPath, animated: Bool)>) -> Disposable {
        signal.map{ (row: $0.indexPath.row, animated: $0.animated) }.bind(to: signals.indexSelected)
    }
    
    private func setupIndexSelected(with signal: Observable<Int>, dataSource: Observable<[TopSegmentCollectionViewModelProtocol]>) -> Disposable {
        signal.withLatestFrom(dataSource) { ($1, $0) }
            .subscribe(onNext: { [weak self] (dataSource, index) in
                dataSource.enumerated().forEach {
                    $1.isActive.accept($0 == index)
                }
                self?.signals.invalidateLayout.publish(())
            })
    }
}

