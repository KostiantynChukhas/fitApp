//
//  SettingsViewController.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class SettingsViewController: ViewController<SettingsViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        tableView.register(cell: DefaultSettingCell.self)
        tableView.register(cell: ActionSettingCell.self)
        tableView.register(cell: SwitcherSettingCell.self)
        tableView.register(cell: SettingHeaderCell.self)
        tableView.register(cell: SettingsSpaceerCell.self)
        
        tableView.contentInset = .init(top: .zero, left: .zero, bottom: 20, right: .zero)
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = SettingsViewModel.Input(
            backSignal: backButton.rx.tap.asObservable(),
            modelSelected: tableView.rx.modelSelected(SettingType.self).asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: SettingsViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items)
        ])
    }
    
    private func setupItemsObserving(with signal: Driver<[SettingType]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { [unowned self] tv, row, model in
                switch model {
                case .action(let model):
                    let cell = tv.dequeueReusableCell(ofType: ActionSettingCell.self, at: .init(row: row))
                    cell.configure(model: model, disposeBag: self.disposeBag)
                    return cell
                case .default(let model):
                    let cell = tv.dequeueReusableCell(ofType: DefaultSettingCell.self, at: .init(row: row))
                    cell.configure(model: model, disposeBag: self.disposeBag)
                    return cell
                case .switcher(let model):
                    let cell = tv.dequeueReusableCell(ofType: SwitcherSettingCell.self, at: .init(row: row))
                    cell.configure(model: model, disposeBag: self.disposeBag)
                    return cell
                case .header(let title):
                    let cell = tv.dequeueReusableCell(ofType: SettingHeaderCell.self, at: .init(row: row))
                    cell.configure(with: title)
                    return cell
                case .spacer:
                    let cell = tv.dequeueReusableCell(ofType: SettingsSpaceerCell.self, at: .init(row: row))
                    return cell
                }
            }
    }
}

