//
//  AnalyticsMeasurementsViewController.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class AnalyticsMeasurementsViewController: ViewController<AnalyticsMeasurementsViewModel> {
    
    @IBOutlet weak var segmentView: AnalyticsContainerView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = AnalyticsMeasurementsViewModel.Input(
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: AnalyticsMeasurementsViewModel.Output) {
        disposeBag.insert([
        ])
    }

}

