//
//  LibraryCategoryViewController.swift
//  fitapp
//
//  on 11.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

class LibraryCategoryViewController: ViewController<LibraryCategoryViewModel> {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.setHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.setHidden(false)
    }
    
    private func setupUI() {
        applyButton.roundCorners(radius: 12)
        defaultButton.roundCorners(radius: 12)
    }
    
    override func setupView() {
        setupTableView()
        setupUI()
    }
    
    override func setupLocalization() {
    }
    
    override func setupOutput() {
        let input = LibraryCategoryViewModel.Input(
            disposeBag: disposeBag,
            backSignal: backButton.rx.tap.asObservable(),
            applySignal: applyButton.rx.tap.asObservable(),
            defaultSignal: defaultButton.rx.tap.asObservable(),
            modelSelected: tableView.rx.modelSelected(TagCategoryModel.self).asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: LibraryCategoryViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setupLibraryListObserving(with: input.tableItemsObservable)
        )
    }
    
    private func setupTableView() {
        tableView.registerCellNib(LibraryCategoryTableViewCell.self)
    }
    
    private func setupLibraryListObserving(with signal: Driver<[TagCategoryModel]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { tv, row, model in
                let cell = tv.dequeueReusableCell(ofType: LibraryCategoryTableViewCell.self, at: .init(row: row))
                cell.configure(with: model)
                return cell
        }
    }
    
}

