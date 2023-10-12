//
//  ProfilePhotosViewController.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import RxDataSources
import ImageViewer_swift

class ProfilePhotosViewController: ViewController<ProfilePhotosViewModel> {
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: .zero, left: 10, bottom: .zero, right: 10)
        let width = (view.frame.width - 40) / 3
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }()
    
    private let activityIndicator = CustomActivityIndicator()
    
    private let photoSelectedSubject = PublishSubject<UIImage>()
    
    override func setupView() {
        super.setupView()
        
        addPhotoButton.layer.cornerRadius = 6
        collectionView.collectionViewLayout = flowLayout
        collectionView.registerCellClass(PhotoCell.self)
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupOutput() {
        let input = ProfilePhotosViewModel.Input(
            photoSelected: photoSelectedSubject.asObservable(), 
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: ProfilePhotosViewModel.Output) {
        disposeBag.insert([
            setupActivityIndicatorObserving(with: input.loading),
            setupDataSourceObserving(with: input.photos),
            setupEmptyObserving(with: input.photos),
            setupCanAddPhotosObserving(with: input.canAdd),
            setupAddPhotoObserving()
        ])
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setupDataSourceObserving(with signal: BehaviorRelay<[PhotoModelUrl]>) -> Disposable {
        signal
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) { collectionView, row, model -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(ofType: PhotoCell.self, at: IndexPath(row: row, section: 0))
                cell.render(with: model)

                cell.imageView.setupImageViewer(
                    urls: signal.value.compactMap { $0.url },
                    initialIndex: row,
                    options: [ .theme(.dark) ],
                    from: self
                )
                
                return cell
            }
    }
    
    private func setupEmptyObserving(with signal: BehaviorRelay<[PhotoModelUrl]>) -> Disposable {
        signal
            .asDriver(onErrorJustReturn: []).map { $0.isEmpty }
            .drive { [weak self] in
            self?.collectionView.isHidden = $0
            self?.emptyView.isHidden = !$0
        }
    }
    
    private func setupCanAddPhotosObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] in
            self?.addPhotoButton.isHidden = !$0
        }
    }
    
    private func setupAddPhotoObserving() -> Disposable {
        addPhotoButton.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, _) in
                let picker = ImagePickerManager()
                
                picker.pickImage(self) { image in
                    self.photoSelectedSubject.onNext(image)
                }
            })
    }
}
