//
//  TopSegmentView.swift
//  fitapp
//
//  Created by on 24.05.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TopSegmentView: FitView {
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 8)
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerCellClass(TopSegmentCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let dataSource: BehaviorRelay<[TopSegmentCollectionViewModelProtocol]> = .init(value: [])
    private let disposeBag: DisposeBag = .init()
    
    override func setupView() {
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
        collectionView.registerCellClass(TopSegmentCollectionViewCell.self)
    }
    
    override func setupConstraints() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension TopSegmentView: NonReusableViewProtocol {
    
    func setupOutput(_ viewModel: TopSegmentViewModel) {
        
        let itemSelected = collectionView.rx.itemSelected.asObservable().filter { [weak self] indexPath in
            guard let viewModel = self?.dataSource.value[indexPath.row] else { return false }
            return !viewModel.isActive.value
        }.compactMap { [weak self] indexPath -> (indexPath: IndexPath, animated: Bool)? in
            guard let self = self, let index = self.dataSource.value.firstIndex(where: { $0.isActive.value == true })
            else { return nil }

            let animated = indexPath.row == index + 1 || indexPath.row == index - 1
            return (indexPath: indexPath, animated: animated)
        }
        
        let input = TopSegmentViewModel.Input(itemSelected: itemSelected,
                                              disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupInput(input: TopSegmentViewModel.Output) {
        disposeBag.insert([
            input.dataSource.asDriver().drive(self.dataSource),
            setupDataSourceObserving(with: self.dataSource.asDriver()),
            setupSelectionObserving(with: input.indexSelectedObserver),
            setupInitialIndex(with: input.setInitialIndex),
            setupInvalidateLayoutObserving(with: input.invalidateLayoutObserver),
        ])
    }
    
    private func setupDataSourceObserving(with signal: Driver<[TopSegmentCollectionViewModelProtocol]>) -> Disposable {
        signal.drive(collectionView.rx.items) { collectionView, row, viewModel in
            let cell = collectionView.dequeueReusableCell(ofType: TopSegmentCollectionViewCell.self, at: .init(row: row))
            cell.setupOutput(viewModel)
            return cell
        }
    }
    
    private func setupInvalidateLayoutObserving(with signal: Observable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    private func setupSelectionObserving(with signal: Observable<Int>) -> Disposable {
        signal.subscribe(with: self, onNext: {`self`, row in
            self.collectionView.scrollToItem(at: IndexPath(row: row), at: .centeredHorizontally, animated: true)
        })
    }
    
    private func setupInitialIndex(with signal: Observable<Int>) -> Disposable {
        signal.delay(.milliseconds(100), scheduler: MainScheduler.instance).subscribe(with: self, onNext: {`self`, row in
            self.collectionView.scrollToItem(at: IndexPath(row: row), at: .centeredHorizontally, animated: false)
        })
    }
    
}
