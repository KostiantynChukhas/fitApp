//
//  ProfileArticlesViewController.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class ProfileArticlesViewController: ViewController<ProfileArticlesViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        tableView.registerCellNib(LibraryTableViewCell.self)
        addCenterActivityView(activityIndicator)
    }
    
    override func setupOutput() {
        let input = ProfileArticlesViewModel.Input(
            modelSelected: tableView.rx.modelSelected(LibraryList.self).asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: ProfileArticlesViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items)
        ])
    }
    
    private func setupItemsObserving(with signal: Driver<[LibraryList]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { [unowned self] tv, row, model in
                let cell = tv.dequeueReusableCell(ofType: LibraryTableViewCell.self, at: .init(row: row))
                cell.configure(with: model, disposeBag: disposeBag)
                return cell
            }
    }
}

