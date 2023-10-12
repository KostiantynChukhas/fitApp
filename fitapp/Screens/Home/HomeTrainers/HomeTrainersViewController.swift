//
//  HomeTrainersViewController.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 02.07.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class HomeTrainersViewController: ViewController<HomeTrainersViewModel> {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = .zero
        return layout
    }()
    
    override func setupView() {
        super.setupView()
        
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = .init(top: .zero, left: .zero, bottom: 20, right: .zero)
        collectionView.registerCellNib(TrainerCollectionCell.self)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        configureSearchBar()
        addCenterActivityView(activityIndicator)
    }
    
    // TODO: - make separate component with this configuration inside
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
        let input = HomeTrainersViewModel.Input(
            indexSelected: collectionView.rx.itemSelected.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: HomeTrainersViewModel.Output) {
        disposeBag.insert([
            setupActivityIndicatorObserving(with: input.isLoading),
            setupDataSourceObserving(with: input.items)
        ])
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setupDataSourceObserving(with signal: Driver<[TrainerCollectionCellViewModel]>) -> Disposable {
        signal.drive(collectionView.rx.items) { collectionView, row, model in
            let cell = collectionView.dequeueReusableCell(ofType: TrainerCollectionCell.self, at: .init(row: row))
            cell.render(with: model)
            return cell
        }
    }

}

extension HomeTrainersViewController: UISearchBarDelegate {
    
}

extension HomeTrainersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 32
        
        let width = (view.frame.width - inset - 15) / 2
        let height: CGFloat = width / (164 / 240)
        return CGSize(width: width, height: height)
    }
}
