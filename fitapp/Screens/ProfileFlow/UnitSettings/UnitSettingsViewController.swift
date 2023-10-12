//
//  UnitSettingsViewController.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class UnitSettingsViewController: ViewController<UnitSettingsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        tableView.registerCellNib(UnitSettingCell.self)
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = UnitSettingsViewModel.Input(
            backSignal: backButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: UnitSettingsViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items)
        ])
    }
    
    private func setupItemsObserving(with signal: Driver<[UnitSettingCellViewModel]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { [unowned self] tv, row, model in
                let cell = tableView.dequeueReusableCell(ofType: UnitSettingCell.self, at: .init(row: row))
                cell.render(with: model)
                return cell
            }
    }
}
