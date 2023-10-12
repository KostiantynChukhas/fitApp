//
//  NotificationsViewController.swift
//  fitapp
//

//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias Section = SectionModel<Int, NotificationCellViewModel>

class NotificationsViewController: ViewController<NotificationsViewModel> {
 
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private let activityIndicator = CustomActivityIndicator()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<Section> = { [unowned self] in
        RxTableViewSectionedReloadDataSource<Section>(configureCell: { _, tableView, index, model in
            let cell = tableView.dequeueReusableCell(ofType: NotificationCell.self, at: index)
            cell.render(with: model)
            return cell
        }, canEditRowAtIndexPath: { _, _ in
            return true
        })
    }()
    
    override func setupView() {
        tableView.registerCellNib(NotificationCell.self)
        tableView.tableFooterView = .init(frame: .zero)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = NotificationsViewModel.Input(
            backSignal: backButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: NotificationsViewModel.Output) {
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
    
    private func setupItemsObserving(with signal: Driver<[NotificationCellViewModel]>) -> Disposable {
        signal.asObservable()
            .map { [Section(model: 0, items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
    }
    
}


// MARK: - UITableViewDelegate

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .normal, title: "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                success(true)
            }
        )
    
        deleteAction.backgroundColor = UIColor(hexString: "#F35A5E")
        deleteAction.image = UIImage(named: "Trash")?.withTintColor(.white)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}

