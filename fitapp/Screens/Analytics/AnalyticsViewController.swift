//
//  AnalyticsViewController.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import ScrollableSegmentedControl

class AnalyticsViewController: ViewController<AnalyticsViewModel> {
    
    @IBOutlet weak var segmentView: AnalyticsContainerView!
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
        let input = AnalyticsViewModel.Input(
            disposeBag: disposeBag,
            selectedSegmentTypeIndex: selectedType.asObserver(),
            notificationsSignal: notificationsButton.rx.tap.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: AnalyticsViewModel.Output) {
        disposeBag.insert([
            setupAnalyticsSegmentViewModel(with: input.analyticsSegmentViewModel)
        ])
    }
    
    private func setupSegmentControll() {
        let largerTextAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: Style.Font.latoBold.uiFont.withSize(16), NSAttributedString.Key.foregroundColor: Style.Color.buttonColor.uiColor]
       
        
        segmentedControl.setTitleTextAttributes(largerTextAttributes, for: .normal)
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Stats", at: 0)
        segmentedControl.insertSegment(withTitle: "Measurements", at: 1)
        segmentedControl.underlineSelected = true
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        // change some colors
        segmentedControl.segmentContentColor = Style.Color.background.uiColor
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Style.Color.starship.uiColor
    }
    
    @objc private func segmentSelected(sender: ScrollableSegmentedControl) {
            self.segmentView.analyticsSegmentView.scrollTo(index: sender.selectedSegmentIndex)
    }
    
    private func setupAnalyticsSegmentViewModel(with signal: Observable<AnalyticsSegmentViewModel>) -> Disposable {
        signal.bind(onNext: { [weak self] viewModel in
            self?.segmentView.analyticsSegmentView.setupOutput(viewModel)
        })
    }
}
