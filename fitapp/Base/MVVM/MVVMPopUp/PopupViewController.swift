//
//  PopupViewController.swift
//  MVVM
//

import UIKit

open class PopupViewController: UIViewController {
    private var popUpContainer: UIStackView = .init(axis: .vertical)
    private var actionButtonsStack: UIStackView = .init(axis: .horizontal)
    private var titleLabel: UILabel = .init()
    private var messageLabel: UILabel = .init()
    private var closeButton: UIButton = .init()
    private var emptySpacingView: UIView = .init()
    public var completionBlock: (() -> Void)?
    private var actionButtons: [PopupActionButton] = []

    public init(title: String?, message: String?) {
        titleLabel.text = title
        messageLabel.text = message
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
        addButtons()
        view.backgroundColor = UIColor(red: 0.22, green: 0.08, blue: 0.26, alpha: 0.9)
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        actionButtons.map { $0.roundCorners(corners: .allCorners, radius: 25.0) }
        popUpContainer.roundCorners(corners: .allCorners, radius: 15.0)
    }

    public func addActionButtons(buttons: [PopupActionButton]) {
        actionButtons = buttons
    }

    private func addButtons() {
        actionButtons.forEach { btn in
            let containerView = UIView()
            actionButtonsStack.addArrangedSubview(containerView)
            containerView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 135.0, height: 50.0))
                make.centerX.centerY.equalToSuperview()
            }
            btn.setBackgroundColor(color: .red, forState: .normal)
        }

        actionButtons.forEach { btn in
            btn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        }
    }

    @objc
    func handleTap(_ sender: PopupActionButton) {
        switch sender.actionType {
        case .okay:
            sender.actionHandler?(true)

        case .cancel:
            sender.actionHandler?(false)
        }
    }

    private func setupViews() {
        view.addSubview(popUpContainer)
        view.addSubview(closeButton)

        popUpContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16.0)
            make.height.greaterThanOrEqualTo(197.0)
        }

        popUpContainer.addArrangedSubview(titleLabel)
        popUpContainer.addArrangedSubview(messageLabel)
        popUpContainer.addArrangedSubview(actionButtonsStack)
        popUpContainer.addArrangedSubview(emptySpacingView)

        actionButtonsStack.snp.makeConstraints { make in
            make.height.equalTo(50.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.centerX.equalToSuperview()
        }

        emptySpacingView.snp.makeConstraints { make in
            make.height.equalTo(10.0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(16.0)
        }

        messageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
        }

        closeButton.snp.makeConstraints { make in
            make.top.right.equalTo(popUpContainer).inset(5.0)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }

    @objc
    func handleCloseButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
        completionBlock?()
    }

    private func setupStyles() {
        popUpContainer.distribution = .equalSpacing
        popUpContainer.spacing = 10.0
        popUpContainer.backgroundColor = .white

        actionButtonsStack.spacing = 25.0
        actionButtonsStack.distribution = .fillProportionally
        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center

        view.bringSubviewToFront(closeButton)
        closeButton.setImage(#imageLiteral(resourceName: "crossBlack"), for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButton(_:)), for: .touchUpInside)

        let titleFont = UIFont(name: "Poppins-Bold", size: 19.0) ?? UIFont.systemFont(ofSize: 19.0)
        let messageFont = UIFont(name: "Roboto-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)

        titleLabel.font = titleFont
        titleLabel.numberOfLines = 0

        messageLabel.font = messageFont
        messageLabel.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.00)
        messageLabel.numberOfLines = 0
    }
}

open class PopupActionButton: UIButton {
    var actionHandler: ((Bool) -> Void)?
    var actionType: PopupActionButtonType = .okay

    public required init(title: String, type: PopupActionButtonType, handler: ((Bool) -> Void)?) {
        super.init(frame: .zero)
        self.actionType = type
        self.actionHandler = handler
        setTitle(title, for: .normal)
        let titleFont = UIFont(name: "Roboto-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        titleLabel?.font = titleFont
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum PopupActionButtonType {
    case okay
    case cancel
}
