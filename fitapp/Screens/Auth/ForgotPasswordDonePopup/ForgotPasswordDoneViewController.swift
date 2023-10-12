//
//  ForgotPasswordDoneViewController.swift
//  fitapp
//
//   on 06.05.2023.
//

import UIKit

class ForgotPasswordDoneViewController: ViewController<ForgotPasswordDoneViewModel> {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var continueButton: RoundedButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = Style.Color.borderColor.uiColor.cgColor
        containerView.layer.cornerRadius = 12
    }
    
    override func setupView() {
        
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupInput(input: ForgotPasswordDoneViewModel.Output) { }
    
    override func setupOutput() {
        let input = ForgotPasswordDoneViewModel.Input(
            continueSignal: continueButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
}
