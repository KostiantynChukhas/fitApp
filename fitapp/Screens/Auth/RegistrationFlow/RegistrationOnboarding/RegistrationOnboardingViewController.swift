//
//  RegistrationOnboardingViewController.swift
//  fitapp
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RegistrationOnboardingViewController: ViewController<RegistrationOnboardingViewModel> {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnNext: RoundedButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    
    private let activityIndicator = CustomActivityIndicator()

    override func setupView() {
        setupCollection()
        addCenterActivityView(activityIndicator)
        btnBack.isHidden = true
    }
    
    override func setupLocalization() {
        progress.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
        progress.roundCorners(radius: 4)
        setupCollection()
    }
    
    override func setupOutput() {
        let input = RegistrationOnboardingViewModel.Input(
            disposeBag: disposeBag,
            tapNextButtonSignal: btnNext.rx.tap.asObservable(),
            tapBackButtonSignal: btnBack.rx.tap.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: RegistrationOnboardingViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setupCollectionViewDataSource(with: input.sections),
            collectionView.rx.setDelegate(self),
            setupNextButtonTitleObserving(with: input.nextButtonTitle),
            setupNextButtonTapObserving(with: input.selectedIndex),
            setupErrorValidate(with: input.errorValidate)
        )
    }
    
    private func setupErrorValidate(with signal: Driver<String>) -> Disposable {
        signal.drive(onNext: { message in
            guard !message.isEmpty else { return }
            AlertManager.showFitAppAlert(msg: message)
        })
    }
    
    private func setupCollectionViewDataSource(
        with signal: Driver<[ExploreSectionModel]>
    ) -> Disposable {
        return signal.drive(collectionView.rx.items(dataSource: self.dataSource()))
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<ExploreSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<ExploreSectionModel>(configureCell: { (dataSource, collectionView, indexPath, section) -> UICollectionViewCell in
            switch section {
            case .tellUs(model: let model):
                let cell: TellAboutYourselfCell = collectionView.dequeue(id: TellAboutYourselfCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            case .tellAboutYourself(model: let model):
                let cell = collectionView.dequeue(id: WitchAreasCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            case .whatMotivates(model: let model):
                let cell: WhatMotivatesCell = collectionView.dequeue(id: WhatMotivatesCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            case .whatsYourName(model: let model):
                let cell = collectionView.dequeue(id: WatsYourNameCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            case .whatsYourBirth(model: let model):
                let cell = collectionView.dequeue(id: WatsYourBirthCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            case .whatsYourCurrentWeight(model: let model):
                let cell: WatsYourCurrentWeightCell = collectionView.dequeue(id: WatsYourCurrentWeightCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            }
        })
        
    }
    
    private func setupNextButtonTitleObserving(with signal: Driver<String>) -> Disposable {
        signal.drive(onNext: { [weak self] in
            self?.btnNext.setTitle($0, for: .normal)
        })
    }
    
    private func setupNextButtonTapObserving(with signal: Driver<Int>) -> Disposable {
        signal.drive(onNext: { [weak self] in
            self?.progress.progress =  Float($0) / Float(8)
            self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: $0), at: .centeredHorizontally, animated: true)
            self?.btnBack.isHidden = $0 == 0
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func setupCollection() {
        collectionView.register([TellAboutYourselfCell.identifier,
                                 WitchAreasCell.identifier,
                                 WhatMotivatesCell.identifier,
                                 WatsYourNameCell.identifier,
                                 WatsYourBirthCell.identifier,
                                 WatsYourCurrentWeightCell.identifier])
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.contentInset = .zero
        collectionView.contentOffset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = true
    }
    
    deinit {
        printDeinit(self)
    }
}

extension RegistrationOnboardingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

