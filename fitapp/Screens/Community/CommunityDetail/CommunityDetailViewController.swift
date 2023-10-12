//
//  CommunityDetailViewController.swift
//  fitapp
//
//  Created by on 15.05.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import IQKeyboardManagerSwift

class CommunityDetailViewController: ViewController<CommunityDetailViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var replyNameLabel: UILabel!
    @IBOutlet weak var replyImgView: UIImageView!
    
    @IBOutlet weak var heightReplyViewConstraint: NSLayoutConstraint!
    
    private var placeholderLabel: UILabel!
    private let activityIndicator = CustomActivityIndicator()
    private var animator: UIViewPropertyAnimator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.setHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.setHidden(false)
    }
    
    private func setupUI() {
        self.commentView.roundCorners(corners: [.topLeft, .topRight], radius: 32)
        commentTextField.delegate = self
        
        addCommentButton.rx.tap.subscribe { [weak self] event in
            self?.dismissReplyView()
        }
        .disposed(by: disposeBag)
        
        self.replyImgView.roundCorners(radius: 4)
    }
    
    override func setupView() {
        addCenterActivityView(activityIndicator)
        setupTableView()
        setupUI()
        dismissReplyView()
    }
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = CommunityDetailViewModel.Input(
            disposeBag: disposeBag,
            backSignal: backButton.rx.tap.asObservable(),
            commentText: commentTextField.rx.text.ignoreNil(),
            modelIndexSelected: tableView.rx.itemSelected.asObservable(),
            modelSelected: tableView.rx.modelSelected(CommunityModelSectionType.self).asObservable(),
            sendCommentSignal: addCommentButton.rx.tap.asObservable()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: CommunityDetailViewModel.Output) {
        disposeBag.insert([
            setupTableViewDataSource(with: input.sections),
            setupActivityIndicatorObserving(with: input.isLoading),
            setupClearTextFieldObserving(with: input.isClearTextField),
            setupReplyObserving(with: input.replySelected)
        ])
    }
    
    private func setupReplyObserving(with signal: Driver<CommunityCommentsData?>) -> Disposable {
        signal
            .drive { [weak self] model in
                guard let model: CommunityCommentsData = model else {
                    self?.dismissReplyView()
                    return
                }
                self?.replyNameLabel.text = model.modelAccount?.name ?? ""
                self?.showTextView()
                
                guard let profilePictureString = model.modelAccount?.avatar, let url = URL(string: profilePictureString) else { return }
                self?.replyImgView.kf.setImage(with: url)
            }
            
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setupClearTextFieldObserving(with signal: Driver<Void>) -> Disposable {
        signal.drive(onNext: { [weak self] _ in
            self?.commentTextField.text = nil
            self?.view.endEditing(true)
        })
    }
    
    private func dismissReplyView() {
        heightReplyViewConstraint.constant = 0
    }
    
    private func showTextView() {
        heightReplyViewConstraint.constant = 32
    }
    
    private func setupTableView() {
        tableView.registerCellNib(CommunityCell.self)
        tableView.registerCellNib(CommunityCommentsCell.self)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func setupTableViewDataSource(with signal: Driver<[CommunityModelSectionType]>) -> Disposable {
        signal
            .map { [AnimatableSectionModel<String, CommunityModelSectionType>(model: .empty, items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource()))
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<AnimatableSectionModel<String, CommunityModelSectionType>> {
        return RxTableViewSectionedReloadDataSource<AnimatableSectionModel<String, CommunityModelSectionType>> (configureCell: { (dataSource, tableView, indexPath, section) -> UITableViewCell in
            switch section {
            case .description(model: let model):
                let cell: CommunityCell = tableView.dequeueReusableCell(ofType: CommunityCell.self, at: indexPath)
                cell.configure(with: model)
                return cell
            case .comments(let model):
                let cell: CommunityCommentsCell = tableView.dequeueReusableCell(ofType: CommunityCommentsCell.self, at: indexPath)
                cell.configure(with: model)
                return cell
            }
        })
    }
}

extension CommunityDetailViewController: UITextFieldDelegate { }
