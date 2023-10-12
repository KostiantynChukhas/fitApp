//
//  DeleteAccountPopup.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class DeleteAccountPopup: ViewController<DeleteAccountPopupViewModel> {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [containerView, cancelButton, deleteButton].forEach {
            $0?.layoutIfNeeded()
            $0?.layer.cornerRadius = 12
        }
    }
    
    override func setupView() {
        super.setupView()
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = DeleteAccountPopupViewModel.Input(
            cancelSignal: cancelButton.rx.tap.asObservable(),
            deleteSignal: deleteButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: DeleteAccountPopupViewModel.Output) {
        disposeBag.insert([
            
        ])
    }
}

