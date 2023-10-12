//
//  ChecklistView.swift
//  fitapp
//

import UIKit

enum SelectionMode {
    case single
    case multiple
}

class ChecklistView: UIControl {
    
    // MARK: - Properties
    
    var selectionMode: SelectionMode = .single
    var checklistValueChanged: ((Set<String>, Int) -> Void)?
    fileprivate var currentSelectedButton: UIButton?

    var options: [String] = [] {
        didSet {
            // Update the view when options are set
            setupCheckList()
        }
    }
    
    var selectedOptions: Set<String> = [] {
        didSet {
            // Notify the value changed event when selected options are set
            sendActions(for: .valueChanged)
        }
    }
    
    fileprivate let viewCheckList: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let stackViewHeight = viewCheckList.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return CGSize(width: UIView.noIntrinsicMetric, height: stackViewHeight)
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addSubview(viewCheckList)
        viewCheckList.fillSuperview()
    }
    
    private func setupCheckList() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .leading
        viewCheckList.addSubview(stackView)
        
        for (index, text) in options.enumerated() {
            let radioButton = UIButton(type: .custom)
            radioButton.setImage(UIImage(named: "unselected_radio_button"), for: .normal)
            radioButton.setImage(UIImage(named: "selected_radio_button"), for: .selected)
            radioButton.tag = index
            radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
            
            let labelButton = UIButton(type: .custom)
            labelButton.setTitle(text, for: .normal)
            labelButton.setTitleColor(Style.Color.textColor.uiColor, for: .normal)
            labelButton.contentHorizontalAlignment = .left
            labelButton.titleLabel?.numberOfLines = 3
            labelButton.tag = index
            labelButton.addTarget(self, action: #selector(labelButtonTapped), for: .touchUpInside)
            
            let horizontalStackView = UIStackView(arrangedSubviews: [radioButton, labelButton])
            horizontalStackView.spacing = 10
            horizontalStackView.alignment = .center
            
            stackView.addArrangedSubview(horizontalStackView)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: viewCheckList.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: viewCheckList.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: viewCheckList.centerYAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    private func selectedMultipleItems(_ sender: UIButton) {
        let option = options[sender.tag]
        if let stackView = sender.superview as? UIStackView,
           let radioButton = stackView.arrangedSubviews.first as? UIButton {
            radioButton.isSelected = !radioButton.isSelected
            if radioButton.isSelected {
                selectedOptions.insert(option)
            } else {
                selectedOptions.remove(option)
            }
            
            
            checklistValueChanged?(selectedOptions, sender.tag)
            
            for subview in stackView.arrangedSubviews {
                if let button = subview as? UIButton, button != radioButton {
                    button.isSelected = false
                }
            }
        }
        
        // Send value changed event to the target
        sendActions(for: .valueChanged)
    }
    
    private func selectedOneItem(_ sender: UIButton) {
        let option = options[sender.tag]
        if let stackView = sender.superview as? UIStackView {
            let radioButton = stackView.arrangedSubviews.first as! UIButton
            
            // Update the state of the current and selected radio button
            currentSelectedButton?.isSelected = false
            radioButton.isSelected = true
            currentSelectedButton = radioButton
            
            // Update the answers set
            if radioButton.isSelected {
                if selectionMode == .single {
                    selectedOptions.removeAll()
                }
                selectedOptions.insert(option)
            } else {
                selectedOptions.remove(option)
            }
        }
        
        checklistValueChanged?(selectedOptions, sender.tag)
        // Send value changed event to the target
        sendActions(for: .valueChanged)
    }
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        switch selectionMode {
            
        case .single:
            selectedOneItem(sender)
        case .multiple:
            selectedMultipleItems(sender)
        }
    }
    
    @objc private func labelButtonTapped(_ sender: UIButton) {
        switch selectionMode {
            
        case .single:
            selectedOneItem(sender)
        case .multiple:
            selectedMultipleItems(sender)
        }
    }
}

extension UIView {
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom)
        ])
    }
}
