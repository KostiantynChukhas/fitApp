//
//  HomeMyPlanViewController.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class HomeMyPlanViewController: ViewController<HomeMyPlanViewModel> {
    
    @IBOutlet weak var moreWorkoutsButton: UIButton!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        moreWorkoutsButton.layer.cornerRadius = 12
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupOutput() {
        let input = HomeMyPlanViewModel.Input(
            moreWorkoutsSignal: moreWorkoutsButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: HomeMyPlanViewModel.Output) {
        disposeBag.insert([
            
        ])
    }

}

