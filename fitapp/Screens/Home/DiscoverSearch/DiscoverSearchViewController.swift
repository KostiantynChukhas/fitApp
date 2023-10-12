//
//  DiscoverSearchViewController.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 05.07.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import MBCircularProgressBar

class DiscoverSearchViewController: ViewController<DiscoverSearchViewModel> {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        addCenterActivityView(activityIndicator)
        configureSearchBar()
        setupTableView()
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
    
    private func setupTableView() {
        tableView.registerCellNib(DiscoverSearchCommunityTableViewCell.self)
        tableView.registerCellNib(DiscoverSearchTableViewCell.self)
        tableView.registerCellNib(DiscoverSearchLibraryTableViewCell.self)
        tableView.registerCellNib(DiscoverSearchWorkoutsTableViewCell.self)
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = DiscoverSearchViewModel.Input(
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: DiscoverSearchViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items)
        ])
    }
    
    private func setupItemsObserving(with signal: Driver<[DiscoverSearchSectionType]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { [unowned self] tv, row, model in
                switch model {
                case .search: return UITableViewCell()
                case .community(model: let model):
                    let cell = tv.dequeueReusableCell(ofType: DiscoverSearchCommunityTableViewCell.self, at: .init(row: row))
                    cell.configure(with: model)
                    return cell
                case .library:  return UITableViewCell()
                case .workouts:  return UITableViewCell()
                }
            }
    }

}

extension DiscoverSearchViewController: UISearchBarDelegate {
    
}
