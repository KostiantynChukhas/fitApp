//
//  CommunityViewController.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ScrollableSegmentedControl

class CommunityViewController: ViewController<CommunityViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bestPostsButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelSearchButton: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    private let activityIndicator = CustomActivityIndicator()
    private var selectedType = PublishSubject<TypeCommunityPage>()
    
    private var menuItems: [UIAction] {
        return [
            UIAction(title: "Standard item", image: UIImage(systemName: "sun.max"), handler: { (_) in
            }),
            UIAction(title: "Disabled item", image: UIImage(systemName: "moon"), attributes: .disabled, handler: { (_) in
            }),
            UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
            })
        ]
    }

    private var demoMenu: UIMenu {
        return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    override func setupView() {
        addCenterActivityView(activityIndicator)
        setupSegmentControll()
        setupTableView()
        configureBestPostsButton()
        configureSearchBar()
        setupButtonsTap()
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = CommunityViewModel.Input(
            disposeBag: disposeBag,
            chooseCategorySignal: tableView.rx.modelSelected(CommunityCellViewModel.self).asObservable(),
            addPostButtonSignal: addButton.rx.tap.asObservable(),
            selectedType: selectedType.asObserver(),
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
                .asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: CommunityViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items)
        ])
    }
    
    private func configureSearchBar() {
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
    }
    
    private func setupButtonsTap() {
        self.searchView.isHidden = true
        
        let searchButton = searchButton.rx.tap.asObservable()
        searchButton
            .subscribe(onNext: { [weak self] in
                self?.navigationView.isHidden = true
                self?.segmentView.isHidden = true
                self?.searchView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        let cancelSearchButton = cancelSearchButton.rx.tap.asObservable()
        cancelSearchButton
            .subscribe(onNext: { [weak self] in
                self?.navigationView.isHidden = false
                self?.segmentView.isHidden = false
                self?.searchView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    func configureBestPostsButton() {
        bestPostsButton.menu = demoMenu
        bestPostsButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupTableView() {
        tableView.registerCellNib(CommunityCell.self)
    }
    
    private func setupItemsObserving(with signal: Driver<[CommunityCellViewModel]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { tv, row, model in
                let cell = tv.dequeueReusableCell(ofType: CommunityCell.self, at: .init(row: row))
                cell.configure(with: model)
                return cell
            }
    }
    
    private func setupSegmentControll() {
        let largerTextAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: Style.Font.latoBold.uiFont.withSize(16), NSAttributedString.Key.foregroundColor: Style.Color.buttonColor.uiColor]
       
        
        segmentedControl.setTitleTextAttributes(largerTextAttributes, for: .normal)
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Home", at: 0)
        segmentedControl.insertSegment(withTitle: "Popular", at: 1)
        segmentedControl.insertSegment(withTitle: "News", at: 2)
        segmentedControl.underlineSelected = true
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        // change some colors
        segmentedControl.segmentContentColor = Style.Color.background.uiColor
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Style.Color.starship.uiColor
    }
    
    @objc func segmentSelected(sender: ScrollableSegmentedControl) {
        guard let type = TypeCommunityPage(rawValue: sender.selectedSegmentIndex) else { return }
        selectedType.onNext(type)
    }
}

extension CommunityViewController: UISearchBarDelegate {

}
