//
//  LibraryViewController.swift
//  fitapp
//
//  on 07.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

class LibraryViewController: ViewController<LibraryViewModel> {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dayIntervalLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterButton: FitBadgeButton!
    @IBOutlet weak var notificationAlert: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightTags: NSLayoutConstraint!
    private let activityIndicator = CustomActivityIndicator()
    private var heightHeaderSize = BehaviorRelay<CGFloat>(value: 0)
        
    private func setupUI() {
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        
        searchBar.addBorder(color: Style.Color.borderColor.uiColor, width: 1)
        searchBar.roundCorners(radius: 12)
        searchBar.textField?.textColor = Style.Color.lightTextColor.uiColor
        
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        searchBar.textField?.placeholder = "Search"
        searchBar.delegate = self
        
        let interval = DayInterval.getDayInterval()
        self.dayIntervalLabel.text = "Good \(interval)!"
    }
    
    override func setupView() {
        setupCollection()
        setupTableView()
        setupUI()
    }
    
    override func setupLocalization() {
    }
    
    override func setupOutput() {
        let input = LibraryViewModel.Input(
            disposeBag: disposeBag,
            filteredButtonSignal: filterButton.rx.tap.asObservable(),
            selectableTags: LibraryCategoryService.shared.selectedCategory,
            searchSignal: searchBar.rx.text
                .orEmpty
                .debounce(DispatchTimeInterval.seconds(Int(0.5)), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .filter { $0.count > 3}
                .asObservable(),
            emptySearchSignal: searchBar.rx.text
                .orEmpty
                .map { $0.isEmpty }
                .startWith(true)
                .asObservable(),
            modelSelected: tableView.rx.modelSelected(LibraryList.self).asObservable(),
            notificationsSignal: notificationAlert.rx.tap.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: LibraryViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setupItemsObserving(with: input.tagsObservable),
            setupLibraryListObserving(with: input.itemsObservable),
            setupBadgeObserving(with: input.tagsObservable),
            tableView.rx.setDelegate(self),
            setupHeaderObserving(with: input.tagsObservable.map { $0.isEmpty })
        )
    }
    
    private func setupBadgeObserving(with signal: Driver<[TagCategoryModel]>) -> Disposable{
        signal.drive { [weak self] tags in
            self?.filterButton.badgeValue = tags.count == 0 ? .empty : "\(tags.count)"
            self?.heightTags.constant = tags.count == 0 ? 0 : 34
        }
    }
    
    private func setupItemsObserving(with signal: Driver<[TagCategoryModel]>) -> Disposable {
        signal
            .drive(tagsCollectionView.rx.items) { collectionView, row, model in
                let cell = collectionView.dequeueReusableCell(ofType: LibraryTagsCollectionViewCell.self, at: .init(row: row))
                cell.configure(with: model)
                return cell
            }
    }
    
    private func setupLibraryListObserving(with signal: Driver<[LibraryList]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { [unowned self] tv, row, model in
                let cell = tv.dequeueReusableCell(ofType: LibraryTableViewCell.self, at: .init(row: row))
                cell.configure(with: model, disposeBag: self.disposeBag)
                return cell
            }
    }
    
    private func setupHeaderObserving(with signal: Driver<Bool>) -> Disposable {
        return signal.drive { [weak self] isShow in
            guard isShow else {
                let emptyView = UIView()
                emptyView.backgroundColor = .clear
                self?.heightHeaderSize.accept(0)
                self?.tableView.rx.viewForHeaderInSection.onNext([.zero: emptyView])
                self?.tableView.reloadData()
                return
            }
         
            let headerView: HeaderCategory = HeaderCategory()
            self?.heightHeaderSize.accept(40)
            self?.tableView.rx.viewForHeaderInSection.onNext([.zero: headerView])
            self?.tableView.reloadData()
        } onCompleted: {
            // No-op or additional cleanup if needed
        }
    }
    
    private func setupCollection() {
        tagsCollectionView.register([LibraryTagsCollectionViewCell.identifier])
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 120, height: 34)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        tagsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tagsCollectionView.contentOffset = .zero
        tagsCollectionView.contentInsetAdjustmentBehavior = .never
        tagsCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        tagsCollectionView.collectionViewLayout = layout
    }
    
    private func setupTableView() {
        tableView.registerCellNib(LibraryTableViewCell.self)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightHeaderSize.value
    }
}

extension LibraryViewController: UISearchBarDelegate {

}
