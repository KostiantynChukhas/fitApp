//
//  HomeViewController.swift
//  fitapp
//
// on 09.05.2023.
//

import UIKit
import RxSwift
import RxCocoa
import ScrollableSegmentedControl

class HomeViewController: ViewController<HomeViewModel> {
    
    @IBOutlet weak var segmentView: HomeContainerView!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var notificationsButton: UIButton!
    
    private var selectedType = PublishSubject<Int>()

    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        addCenterActivityView(activityIndicator)
        setupSegmentControll()
    }
    
    override func setupLocalization() {
     
    }
    
    override func setupOutput() {
        let input = HomeViewModel.Input(
            disposeBag: disposeBag,
            selectedSegmentTypeIndex: selectedType.asObserver(),
            notificationsSignal: notificationsButton.rx.tap.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: HomeViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setupHomeSegmentViewModel(with: input.homeSegmentViewModel)
        )
    }
    
    private func setupSegmentControll() {
        let largerTextAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: Style.Font.latoBold.uiFont.withSize(16), NSAttributedString.Key.foregroundColor: Style.Color.buttonColor.uiColor]
       
        
        segmentedControl.setTitleTextAttributes(largerTextAttributes, for: .normal)
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Discover", at: 0)
        segmentedControl.insertSegment(withTitle: "Trainers", at: 1)
        segmentedControl.insertSegment(withTitle: "My Plan", at: 2)
        segmentedControl.underlineSelected = true
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        // change some colors
        segmentedControl.segmentContentColor = Style.Color.background.uiColor
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Style.Color.starship.uiColor
    }
    
    @objc private func segmentSelected(sender: ScrollableSegmentedControl) {
//        selectedType.onNext(sender.selectedSegmentIndex)
            self.segmentView.homeSegmentView.scrollTo(index: sender.selectedSegmentIndex)
    }
    
    private func setupHomeSegmentViewModel(with signal: Observable<HomeSegmentViewModel>) -> Disposable {
        signal.bind(onNext: { [weak self] viewModel in
            self?.segmentView.homeSegmentView.setupOutput(viewModel)
        })
    }
    
}
