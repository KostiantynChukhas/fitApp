//
//  AnalyticsSegmentView.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AnalyticsSegmentView: FitView {
    internal struct Signals {
        fileprivate let didEndScrollToItem: Publisher<Int> = .init()
        fileprivate let analyticsSegmentUpdated: Publisher<Void> = .init()
    }
    
    private let disposeBag: DisposeBag = .init()
    private let signals: Signals = .init()
    private let countDataSource = BehaviorRelay<Int>(value: .zero)
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: frame.width, height: frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.registerCellClass(AnalyticsSegmentCollectionViewCell.self)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = .init(width: frame.width, height: frame.height)
            layout.invalidateLayout()
        }
    }
    
    override func setupView() {
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
    }
    
    override func setupConstraints() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func scrollTo(index: Int) {
        guard countDataSource.value >= 2 else { return }
        collectionView.scrollToItem(at: .init(row: index), at: .centeredHorizontally, animated: true)
    }
}

extension AnalyticsSegmentView: NonReusableViewProtocol {
    
    func setupOutput(_ viewModel: AnalyticsSegmentViewModel) {
        let willDisplayScreenByIndex = collectionView.rx.willDisplayCell.asObservable().map{ $0.at.row }
        let didEndDisplayingScreenByIndex = collectionView.rx.didEndDisplayingCell.asObservable().map{ $0.at.row }

        let input = AnalyticsSegmentViewModel.Input(willDisplayScreenByIndex: willDisplayScreenByIndex,
                                               didEndDisplayingScreenByIndex: didEndDisplayingScreenByIndex,
                                               didEndDeceleratingByIndex: setupDidEndDecelerating(with: collectionView.rx.didEndDecelerating.asObservable()),
                                               didEndScrollToItem: signals.didEndScrollToItem.asObservable(),
                                               analyticsSegmentUpdated: signals.analyticsSegmentUpdated.asObservable(),
                                               disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupInput(input: AnalyticsSegmentViewModel.Output) {
        let indexPathSelected = Observable.merge([
            input.indexPathSelectedObserver,
            input.initialIndexPathSelectedObserver
        ])
        disposeBag.insert([
            setupDataSourceObserving(with: input.dataSource),
            setupCountDataSourceObserving(with: input.dataSource),
            setupAnalyticsSegmentUpdated(with: input.dataSource.asObservable().mapToVoid()),
            setupIndexPathSelected(with: indexPathSelected)
        ])
    }
    
    private func setupAnalyticsSegmentUpdated(with signal: Observable<Void>) -> Disposable {
        signal.delay(.milliseconds(200), scheduler: MainScheduler.instance).bind(to: signals.analyticsSegmentUpdated)
    }
    
    private func setupDataSourceObserving(with signal: Driver<[UIViewController]>) -> Disposable {
        signal.drive(collectionView.rx.items) { collectionView, row, vc in
            let cell = collectionView.dequeueReusableCell(ofType: AnalyticsSegmentCollectionViewCell.self, at: .init(row: row))
            cell.configure(vc: vc)
            return cell
        }
    }
    
    private func setupCountDataSourceObserving(with signal: Driver<[UIViewController]>) -> Disposable {
        signal.drive { [weak self] arrayDataSource in
            self?.countDataSource.accept(arrayDataSource.count)
        }
    }

    private func setupIndexPathSelected(with signal: Observable<(indexPath: IndexPath, animated: Bool)>) -> Disposable {
        signal.subscribe(onNext: { [weak self] indexPath, animation in
            self?.collectionView.isPagingEnabled = false
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animation)
            self?.collectionView.isPagingEnabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                self?.signals.didEndScrollToItem.publish(indexPath.row)
            })
        })
    }
    
    private func setupDidEndDecelerating(with signal: Observable<Void>) -> Observable<Int> {
        signal.map { [weak self] _ -> Int in
            guard let self = self else { return .zero }
            if self.collectionView.contentOffset.x == .zero { return .zero }

            return Int(self.collectionView.contentOffset.x / self.frame.size.width)
        }
    }
}
