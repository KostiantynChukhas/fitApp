//
//  ProfileFeedsViewController.swift
//  fitapp
//
//  Created by on 22.05.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class ProfileFeedsViewController: ViewController<ProfileFeedsViewModel> {
    
    @IBOutlet weak var segmentView: ProfileContainerView!
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        tableView.registerCellNib(CommunityCell.self)
        tableView.contentInset = .init(top: .zero, left: .zero, bottom: 40, right: .zero)
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupOutput() {
        let input = ProfileFeedsViewModel.Input(
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: ProfileFeedsViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items)
        ])
    }
    
    private func setupItemsObserving(with signal: Driver<[CommunityCellViewModel]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { tv, row, model in
                let cell = tv.dequeueReusableCell(ofType: CommunityCell.self, at: .init(row: row))
                cell.configure(with: model)
                return cell
            }
    }
}
