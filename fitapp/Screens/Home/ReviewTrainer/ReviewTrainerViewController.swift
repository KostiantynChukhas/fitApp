//
//  ReviewTrainerViewController.swift
//  fitapp
//
//  Created by  on 23.07.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PanModal

class ReviewTrainerViewController: ViewController<ReviewTrainerViewModel> {
 
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starsView: RateStarsView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photosCollectionView: ReviewPhotosCollectionView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    private let activityIndicator = CustomActivityIndicator()
    
    private let starPublisher = PublishSubject<Int>()
    
    private let addPhotoSubject = PublishSubject<UIImage>()
    
    private let removePhotoSubject = PublishSubject<PhotoModel>()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        reviewButton.layer.cornerRadius = 12
        textView.layer.cornerRadius = 8
    }
    
    override func setupView() {
        starsView.delegate = self
    }
    
    override func setupOutput() {
        let input = ReviewTrainerViewModel.Input(
            reviewSignal: reviewButton.rx.tap.asObservable(),
            closeSignal: closeButton.rx.tap.asObservable(),
            textSignal: textView.rx.text.orEmpty.asObservable(),
            starSignal: starPublisher.asObservable(),
            addPhotoSignal: addPhotoSubject.asObservable(),
            removePhotoSignal: removePhotoSubject.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: ReviewTrainerViewModel.Output) {
        super.setupInput(input: input)
        
        photosCollectionView.render(images: input.images)
        
        disposeBag.insert(
            setupReviewButtonEnablingObserving(with: input.isValid),
            setupAddPhotoClicked(),
            setupRemovePhotoClicked(),
            setupRemovePhotoClicked()
        )
    }
    
    private func setupReviewButtonEnablingObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] in
            self?.reviewButton.isEnabled = $0
            self?.reviewButton.alpha = $0 ? 1.0: 0.5
        }
    }
    
    private func setupAddPhotoClicked() -> Disposable {
        photosCollectionView.addPhotoSubject.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                ImagePickerManager().pickImage(self) { [weak self] image in
                    self?.addPhotoSubject.onNext(image)
                }
            })
    }
    
    private func setupRemovePhotoClicked() -> Disposable {
        photosCollectionView.removePhotoSubject
            .asObservable()
            .bind(to: removePhotoSubject)
    }
    
}

// MARK: - PanModalPresentable

extension ReviewTrainerViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight {
        return .contentHeight(UIScreen.main.bounds.height)
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var panModalBackgroundColor: UIColor {
        return .black.withAlphaComponent(0.7)
    }
    
    var topOffset: CGFloat {
        return .zero
    }
    
    var cornerRadius: CGFloat {
        return .zero
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
}

// MARK: - RateStatsViewDelegate

extension ReviewTrainerViewController: RateStatsViewDelegate {
    func didSelect(value: Int) {
        starPublisher.onNext(value)
    }
    
}
