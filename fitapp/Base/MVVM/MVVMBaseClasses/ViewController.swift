//
//  ViewController.swift
//  MVVM
//


import Foundation
import UIKit

public protocol NonReusableViewProtocol: AnyObject {
    associatedtype ViewModelProtocol
    func setupOutput(_ viewModel: ViewModelProtocol)
}

open class ViewController<ViewModel: ViewModelProtocol>: UIViewController,
                                                         ViewProtocol,
                                                         DeinitAnnouncerType {
    // MARK: - Properties

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // swiftlint:disable:next implicitly_unwrapped_optional
    public var viewModel: ViewModel!

    // MARK: - Constructor

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupDeinitAnnouncer()
    }

    public init(viewModel: ViewModel,
                nibName: String? = nil,
                bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
        setupDeinitAnnouncer()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDeinitAnnouncer()
    }

    // MARK: - Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupView()
        setupScrollCollection()
        setupNavigationBar()
        setupLocalization()
        setupOutput()
    }

    // MARK: - Setup Functions

    /// override to setup constraints. Called in viewDidLoad method.
    open func setupConstraints() {}

    /// override to setup views. Called in viewDidLoad method.
    open func setupView() {}

    /// override to setup localization. Called in viewDidLoad method.
    open func setupLocalization() {}

    /// override to setup collection such as UITableView, UICollectionView or etc. Called in viewDidLoad method.
    open func setupScrollCollection() {}

    /// override to setup view navigation bar appereance. Called in viewDidLoad method.
    open func setupNavigationBar() {}

    // MARK: - ViewProtocol

    open func setupOutput() {}

    open func setupInput(input: ViewModel.Output) {}
}
