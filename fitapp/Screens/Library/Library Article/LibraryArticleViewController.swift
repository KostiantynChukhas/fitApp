//
//  LibraryArticleViewController.swift
//  fitapp
//
//  on 13.05.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class LibraryArticleViewController: ViewController<LibraryArticleViewModel> {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var replyNameLabel: UILabel!
    @IBOutlet weak var replyImgView: UIImageView!
    
    @IBOutlet weak var heightTextViewConstarint: NSLayoutConstraint!
    @IBOutlet weak var heightReplyViewConstraint: NSLayoutConstraint!
    
    private var animator: UIViewPropertyAnimator?
    private let activityIndicator = CustomActivityIndicator()
    private var needShowTextView: Bool = false
    
    private var dropDownManager = DropDownManager()
    
    private func setupUI() {
        self.titleView.alpha = 0
        self.commentView.roundCorners(corners: [.topLeft, .topRight], radius: 32)
        commentTextField.delegate = self
        
        addCommentButton.rx.tap.subscribe { [weak self] event in
            if self?.needShowTextView == true {
                self?.dismissTextView()
                self?.dismissReplyView()
                self?.needShowTextView = false
            } else {
                self?.showTextView()
                self?.needShowTextView = true
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func setupDropDown() {
        dropDownManager.setup(for: view)
        dropDownManager.hide()
    }

    override func setupView() {
        setupTableView()
        setupDropDown()
        setupUI()
        dismissTextView()
        dismissReplyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.setHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.setHidden(false)
    }
    
    override func setupLocalization() {
    }
    
    override func setupOutput() {
        let input = LibraryArticleViewModel.Input(
            disposeBag: disposeBag,
            backButtonSignal: backBtn.rx.tap.asObservable(),
            modelIndexSelected: tableView.rx.itemSelected.asObservable(),
            modelSelected: tableView.rx.modelSelected(LibraryModelSectionType.self).asObservable(),
            commentText: commentTextField.rx.text.ignoreNil(),
            sendCommentSignal: addCommentButton.rx.tap.asObservable(),
            markSignal: bookmarkButton.rx.tap.asObservable(), 
            moreItemSelected: dropDownManager.itemSelected,
            dropDownDismissed: dropDownManager.dismissObservable
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: LibraryArticleViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            tableView.rx.setDelegate(self),
            setupTableViewDataSource(with: input.sections),
            setupActivityIndicatorObserving(with: input.isLoading),
            setupClearTextFieldObserving(with: input.isClearTextField),
            setupReplyObserving(with: input.replySelected),
            setupMoreObserving(with: input.moreSelected),
            setupIsSavedObserving(with: input.isSaved),
            setupScrollToBottomObserving(with: input.scrollToBottom)
        )
    }
    
    private func dismissTextView() {
        heightTextViewConstarint.constant = 0
        bottomView.backgroundColor = Style.Color.background.uiColor
    }
    
    private func showTextView() {
        heightTextViewConstarint.constant = 80
        bottomView.backgroundColor = Style.Color.navigationColor.uiColor
    }
    
    private func showDropdown() {
        dropDownManager.show(with: .comments)
    }
    
    private func dismissDropdown() {
        dropDownManager.hide()
    }
    
    private func dismissReplyView() {
        heightReplyViewConstraint.constant = 0
    }
    
    private func showReplyView() {
        heightTextViewConstarint.constant = 105
        heightReplyViewConstraint.constant = 32
    }
    
    private func setupTableView() {
        tableView.registerCellNib(LibraryArticleDescriptionCell.self)
        tableView.registerCellNib(LibraryArticleRowsCommentsCell.self)
        tableView.registerCellNib(TitleCommentsCell.self)
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.bounces = false

        tableView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: 80, right: .zero)
        tableView.contentOffset = CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude)
        
        tableView.rx.contentOffset
            .map { $0.y }
            .subscribe(onNext: { [weak self] yOffset in
                self?.animator?.stopAnimation(true)
                self?.animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) { [weak self] in
                    self?.titleView.alpha = yOffset < 50 ? 0 : 1
                }
                self?.animator?.startAnimation()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupReplyObserving(with signal: Driver<LibraryCommentsData?>) -> Disposable {
        signal
            .drive { [weak self] model in
                guard let model: LibraryCommentsData = model else {
                    self?.dismissReplyView()
                    return
                }
                self?.replyNameLabel.text = model.modelAccount?.name ?? ""
                self?.showReplyView()
                
                guard let profilePictureString = model.modelAccount?.avatar, let url = URL(string: profilePictureString) else { return }
                self?.replyImgView.kf.setImage(with: url)
            }
    }
    
    private func setupMoreObserving(with signal: Driver<LibraryCommentsData?>) -> Disposable {
        signal
            .drive { [weak self] model in
                self?.showDropdown()
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
    
    private func setupScrollToBottomObserving(with signal: Driver<Void>) -> Disposable {
        signal.drive(onNext: { [weak self] _ in
            self?.tableView.scrollToBottom()
        })
    }
    
    private func setupTableViewDataSource(with signal: Driver<[LibraryModelSectionType]>) -> Disposable {
        signal
            .map { [AnimatableSectionModel<String, LibraryModelSectionType>(model: .empty, items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource()))
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<AnimatableSectionModel<String, LibraryModelSectionType>> {
        return RxTableViewSectionedReloadDataSource<AnimatableSectionModel<String, LibraryModelSectionType>>(
            configureCell: { [unowned self] (dataSource, tableView, indexPath, section) -> UITableViewCell in
                switch section {
                case .description(model: let model):
                    let cell: LibraryArticleDescriptionCell = tableView.dequeueReusableCell(ofType: LibraryArticleDescriptionCell.self, at: indexPath)
                    cell.configure(with: model)
                    return cell
                    
                case .comments(model: let model):
                    let cell: LibraryArticleRowsCommentsCell = tableView.dequeueReusableCell(ofType: LibraryArticleRowsCommentsCell.self, at: indexPath)
                    cell.configure(with: model, disposeBag: self.disposeBag)
                    return cell
                case .titleComments:
                    let cell: TitleCommentsCell = tableView.dequeueReusableCell(ofType: TitleCommentsCell.self, at: indexPath)
                    return cell
                }
            })
    }
        
    private func setupIsSavedObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive(onNext: { [weak self] in
            self?.bookmarkButton.isSelected = $0
        })
    }
}

extension LibraryArticleViewController: UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
}
