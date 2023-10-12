//
//  OnboardingViewController.swift
//
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: ViewController<OnboardingViewModel> {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var btnNext: RoundedButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var btnSkipAction: UIButton!
    
    private let activityIndicator = CustomActivityIndicator()
    private let currentPage = BehaviorRelay<Int>(value: 0)
    
    override func setupView() {
        setupCollection()
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
        btnNext.setTitle("Next", for: .normal)
        btnSkipAction.setTitle("Skip", for: .normal)
    }
    
    override func setupOutput() {
        let input = OnboardingViewModel.Input(
            disposeBag: disposeBag,
            tapNextButtonSignal: btnNext.rx.tap.asObservable(),
            tapSkipButtonSignal: btnSkipAction.rx.tap.asObservable(),
            scrollOnboarding: currentPage.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: OnboardingViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setupItemsObserving(with: input.collectionItemsObservable),
            collectionView.rx.setDelegate(self),
            setupNextButtonTitleObserving(with: input.nextButtonTitle),
            setupNextButtonTapObserving(with: input.selectedIndex)
        )
    }
    
    func setupNextButtonTitleObserving(with signal: Driver<String>) -> Disposable {
        signal.drive(onNext: { [weak self] in
            self?.btnNext.setTitle($0, for: .normal)
        })
    }
    
    func setupNextButtonTapObserving(with signal: Driver<Int>) -> Disposable {
        signal.drive(onNext: { [weak self] in
            self?.pageControl.currentPage = $0
            self?.collectionView.scrollToItem(at: IndexPath(row: $0), at: .centeredHorizontally, animated: true)
        })
    }
    
    func setupItemsObserving(with signal: Driver<[OnboardingData]>) -> Disposable {
        signal
            .do(onNext: { [weak self] data in
                self?.pageControl.numberOfPages = data.count
            })
            .drive(collectionView.rx.items) { collectionView, row, viewModel in
                let cell = collectionView.dequeueReusableCell(ofType: OnboardingCollectionViewCell.self, at: .init(row: row))
                cell.configure(with: viewModel)
                return cell
            }
    }
    
    private func setupCollection() {
        collectionView.registerCellNib(OnboardingCollectionViewCell.self)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: UIScreen().bounds.width, height: UIScreen().bounds.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.contentInset = .zero
        collectionView.contentOffset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.collectionViewLayout = layout
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage.accept(Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentPage.accept(Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))
    }

}

