//
//  HomeWorkoutsViewController.swift
//  fitapp
//
//  Created by Sergey Pritula on 22.08.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeWorkoutsViewController: ViewController<HomeWorkoutsViewModel> {
 
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        tableView.registerCellNib(WorkoutTableCell.self)
        configureSearchBar()
    }
    
    private func configureSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        
        searchBar.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
        searchBar.roundCorners(radius: 12)
        searchBar.textField?.textColor = Style.Color.lightTextColor.uiColor
        
        searchBar.searchTextField.backgroundColor = .white
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        searchBar.textField?.placeholder = "Search"
        searchBar.delegate = self
    }
    
    override func setupOutput() {
        let input = HomeWorkoutsViewModel.Input(
            backSignal: backButton.rx.tap.asObservable(),
            modelSelected: tableView.rx.modelSelected(WorkoutTableCellViewModel.self).asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: HomeWorkoutsViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setupActivityIndicatorObserving(with: input.isLoading),
            setupItemsObserving(with: input.items)
        )
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setupItemsObserving(with signal: Driver<[WorkoutTableCellViewModel]>) -> Disposable {
        signal.drive(tableView.rx.items) { [unowned self] tv, row, model in
            let cell = tableView.dequeueReusableCell(ofType: WorkoutTableCell.self, at: .init(row: row))
            cell.render(model: model)
            return cell
        }
    }
    
}

extension HomeWorkoutsViewController: UISearchBarDelegate {
    
}
