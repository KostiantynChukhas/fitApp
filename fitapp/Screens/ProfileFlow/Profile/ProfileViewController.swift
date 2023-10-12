//
//  ProfileViewController.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import Kingfisher

class ProfileViewController: ViewController<ProfileViewModel> {
    
    @IBOutlet weak var navBarView: ProfileTopBarView!
    @IBOutlet weak var infoView: ProfileInfoView!
    @IBOutlet weak var segmentView: ProfileContainerView!
    @IBOutlet weak var privateProfileView: UIView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    private let avatarImageSubject = PublishSubject<Data>()
    
    override func setupView() {
        addCenterActivityView(activityIndicator)
        
        let tapGesture = UITapGestureRecognizer()
        infoView.containerView.addGestureRecognizer(tapGesture)
        infoView.containerView.isUserInteractionEnabled = true
        
        let tapGestureObservable = tapGesture.rx.event.asObservable()
        
        tapGestureObservable
            .subscribe(onNext: { _ in
                ImagePickerManager().pickImage(self) { [weak self] image in
                    self?.avatarImageSubject.onNext(image.compressToData(sizeInKb: 250) ?? Data())
                }
            }).disposed(by: disposeBag)
    }
    
    override func setupOutput() {
        let info = infoView.getOutput()
        
        let input = ProfileViewModel.Input(
            disposeBag: disposeBag,
            rightButtonSignal: navBarView.editButton.rx.tap.asObservable(),
            leftButtonSignal: navBarView.settingButton.rx.tap.asObservable(),
            uploadImageSignal: avatarImageSubject.asObservable(),
            profileInfo: info
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: ProfileViewModel.Output) {
        disposeBag.insert([
            setupTopSegmentViewModel(with: input.topSegmentViewModel),
            setupMainSegmentViewModel(with: input.mainSegmentViewModel),
            setupProfileTypeObserving(with: input.type),
            setupPrivateObserving(with: input.private)
        ])
    }
    
    private func setupTopSegmentViewModel(with signal: Observable<TopSegmentViewModel>) -> Disposable {
        signal.bind(onNext: { [unowned self] viewModel in
            self.segmentView.topSegmentView.setupOutput(viewModel)
            
            viewModel.signals.indexSelected.asObservable()
                .subscribe { [weak self] (row: Int, animated: Bool) in
                    self?.segmentView.mainSegmentView.scrollTo(index: row)
                }.disposed(by: self.disposeBag)
        })
    }
    
    private func setupMainSegmentViewModel(with signal: Observable<MainSegmentViewModel>) -> Disposable {
        signal.bind(onNext: { [weak self] viewModel in
            self?.segmentView.mainSegmentView.setupOutput(viewModel)
        })
    }
    
    private func setupProfileTypeObserving(with signal: Observable<ProfileType>) -> Disposable {
        signal
            .observe(on: MainScheduler.instance)
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, type) in
                DispatchQueue.main.async {
                    let color = type.isTrainer ? Style.Color.gradientColor.uiColor: UIColor.white
                    self.view.backgroundColor = color
                    self.navBarView.setup(input: .init(type: type))
                    self.infoView.setup(input: .init(type: type))
                }
            })
    }
    
    private func setupPrivateObserving(with signal: Observable<Bool>) -> Disposable {
        signal.bind { [weak self] in
            self?.segmentView.isHidden = $0
            self?.privateProfileView.isHidden = !$0
        }
    }
}
