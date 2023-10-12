//
//  TrainerReviewsViewController.swift
//  fitapp
//
//  Created by  on 29.07.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TrainerReviewsViewController: ViewController<TrainerReviewsViewModel> {
 
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    private let openReviewScreenSubject = PublishSubject<Void>()
    
    override func setupView() {
        tableView.registerCellNib(TrainerReviewCell.self)
        tableView.registerCellNib(RatingTableCell.self)
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupOutput() {
        let input = TrainerReviewsViewModel.Input(
            reviewSignal: openReviewScreenSubject.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: TrainerReviewsViewModel.Output) {
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
    
    private func setupItemsObserving(with signal: Driver<[ReviewItem]>) -> Disposable {
        signal
            .drive(tableView.rx.items) { [unowned self] tv, row, model in
                switch model {
                case .reviewInfo(let data):
                    let cell = tv.dequeueReusableCell(ofType: RatingTableCell.self, at: .init(row: row))
                    cell.render(model: data)
                    
                    cell.leaveFeedbackButton.rx.tap
                        .asObservable()
                        .bind(to: openReviewScreenSubject)
                        .disposed(by: self.disposeBag)
                    
                    return cell
                case .userReview(let model):
                    let cell = tv.dequeueReusableCell(ofType: TrainerReviewCell.self, at: .init(row: row))
                    cell.render(model: model)
                    return cell
                }
            }
    }
    
}
