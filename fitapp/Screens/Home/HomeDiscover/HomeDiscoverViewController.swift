//
//  HomeDiscoverViewController.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import MBCircularProgressBar

class HomeDiscoverViewController: ViewController<HomeDiscoverViewModel> {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var myWorkoutCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutsCollectionView: UICollectionView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterButton: FitBadgeButton!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        addCenterActivityView(activityIndicator)
        configureSearchBar()
        setupCollection()
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
        tableView.registerCellNib(HelpfulTableViewCell.self)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    private func setupCollection() {
        tagsCollectionView.register([LibraryTagsCollectionViewCell.identifier])
        myWorkoutCollectionView.register([MyWorkoutCollectionViewCell.identifier])
        workoutsCollectionView.register([DiskoverWorkoutsCollectionViewCell.identifier])
        
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
        
        let myWorkoutsLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        myWorkoutsLayout.sectionInset = .zero
        myWorkoutsLayout.itemSize = CGSize(width: myWorkoutCollectionView.frame.width, height: myWorkoutCollectionView.frame.height)
        myWorkoutsLayout.minimumInteritemSpacing = 0
        myWorkoutsLayout.minimumLineSpacing = 0
        myWorkoutsLayout.scrollDirection = .horizontal
        myWorkoutCollectionView.contentInset = .zero
        myWorkoutCollectionView.contentOffset = .zero
        myWorkoutCollectionView.contentInsetAdjustmentBehavior = .never
        myWorkoutCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        myWorkoutCollectionView.isScrollEnabled = true
        myWorkoutCollectionView.collectionViewLayout = myWorkoutsLayout
        
        let workoutsLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        workoutsLayout.sectionInset = .zero
        workoutsLayout.itemSize = CGSize(width: 259, height: 160)
        workoutsLayout.minimumInteritemSpacing = 0
        workoutsLayout.minimumLineSpacing = 10
        workoutsLayout.scrollDirection = .horizontal
        workoutsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        workoutsCollectionView.contentOffset = .zero
        workoutsCollectionView.contentInsetAdjustmentBehavior = .never
        workoutsCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        workoutsCollectionView.isScrollEnabled = true
        workoutsCollectionView.collectionViewLayout = workoutsLayout
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = HomeDiscoverViewModel.Input(
            disposeBag: disposeBag,
            filteredButtonSignal: filterButton.rx.tap.asObservable(),
            selectableTags: DiscoverCategoryService.shared.selectedCategory,
            startSearchBarSignal: searchBar.rx.textDidBeginEditing.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: HomeDiscoverViewModel.Output) {
        disposeBag.insert([
            setupMyWorkoutObserving(with: input.myWorkoutsObservable),
            setupHelpfullListObserving(with: input.helpfullObservable),
            setupHelpfullListHeightObserving(with: input.helpfullObservable),
            setupWorkoutsObserving(with: input.workoutsObservable),
            setupItemsObserving(with: input.tagsObservable),
            setupBadgeObserving(with: input.tagsObservable)
            
        ])
    }
    
    private func setupBadgeObserving(with signal: Driver<[TagCategoryModel]>) -> Disposable{
        signal.drive { [weak self] tags in
            self?.filterButton.badgeValue = tags.count == 0 ? .empty : "\(tags.count)"
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
    
    private func setupMyWorkoutObserving(with signal: Driver<[String]>) -> Disposable {
        signal
            .drive(myWorkoutCollectionView.rx.items) { collectionView, row, model in
                let cell = collectionView.dequeueReusableCell(ofType: MyWorkoutCollectionViewCell.self, at: .init(row: row))
//                cell.configure(with: model)
                return cell
            }
    }
    
    private func setupWorkoutsObserving(with signal: Driver<[String]>) -> Disposable {
        signal
            .drive(workoutsCollectionView.rx.items) { collectionView, row, model in
                let cell = collectionView.dequeueReusableCell(ofType: DiskoverWorkoutsCollectionViewCell.self, at: .init(row: row))
//                cell.configure(with: model)
                return cell
            }
    }
    
    private func setupHelpfullListObserving(with signal: Driver<[String]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { [unowned self] tv, row, model in
                let cell = tv.dequeueReusableCell(ofType: HelpfulTableViewCell.self, at: .init(row: row))
//                cell.configure(with: model, disposeBag: self.disposeBag)
                return cell
            }
    }
    
    private func setupHelpfullListHeightObserving(with signal: Driver<[String]>) -> Disposable {
        signal.drive { [weak self] elements in
            self?.tableViewConstraint.constant = CGFloat(elements.count * 200)
        }
    }

}

extension HomeDiscoverViewController: UISearchBarDelegate {
    
}
