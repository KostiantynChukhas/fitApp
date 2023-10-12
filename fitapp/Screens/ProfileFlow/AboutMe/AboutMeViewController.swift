//
//  AboutMeViewController.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class AboutMeViewController: ViewController<AboutMeViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        tableView.registerCellNib(AboutMeCell.self)
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = AboutMeViewModel.Input(
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: AboutMeViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items)
        ])
    }
    
    private func setupItemsObserving(with signal: Driver<[AboutMeCellViewModel]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { tv, row, model in
                let cell = tv.dequeueReusableCell(ofType: AboutMeCell.self, at: .init(row: row))
                cell.configure(category: model.type.title, title: model.text)
                return cell
            }
    }
}
