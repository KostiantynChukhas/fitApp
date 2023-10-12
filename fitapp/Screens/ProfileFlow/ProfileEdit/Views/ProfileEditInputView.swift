//
//  ProfileEditInputView.swift
//  fitapp
//
//  on 22.05.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileEditInputView: FitView {
    
    struct Constants {
        struct Image {
            static let send = UIImage()
        }
        
        struct Size {
            static let defaultHeight: CGFloat = 49
            static let radius: CGFloat = 12
            static let maxHeight: CGFloat = 450
        }
        
        enum Colors {
            static let messageLimitExceedColor = UIColor.red
            static let defaultMessageViewBorderColor = Style.Color.borderColor.uiColor
        }
    }
    
    // MARK: - Properties
    
    private(set) var container = UIView()
    
    private(set) var textView = UITextView()
    
    private var textViewHeight: ConstraintMakerEditable!
    
    private(set) var isEditing = false
    
    private var placeholderLabel : UILabel!
    
    var maxLength = 140
    
    var highlightsOnMaxLength = false
    
    var enabled: Bool = true {
        didSet {
            isUserInteractionEnabled = enabled
            alpha = enabled ? 1 : 0.5
            
            textView.text = enabled ? "addComment" : "commentsDisabled"
            
            guard !enabled else { return }
            
            textView.resignFirstResponder()
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.layer.cornerRadius = Constants.Size.radius
    }
    
    override func setupConstraints() {
        addSubview(container)
        container.addSubview(textView)
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().offset(5)
            $0.top.bottom.equalToSuperview()
            self.textViewHeight = $0.height.equalTo(Constants.Size.defaultHeight)
        }
    }
    
    override func setupView() {
        backgroundColor = .white
        
        container.layer.borderWidth = 1
        container.layer.borderColor = Style.Color.borderColor.uiColor.cgColor
        container.backgroundColor = .white
        
        textView.backgroundColor = .white
        textView.textColor = Style.Color.textColor.uiColor
        textView.isScrollEnabled = true
        textView.delegate = self
        textView.font = Style.Font.latoBold.uiFont.withSize(14)
        textView.contentInset = .zero
        textView.contentOffset = .zero
    }
    
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    private var notMaxTextLength: Bool {
        textView.text.count < maxLength
    }
    
    func addPlaceholder(with text: String) {
        placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = Style.Font.latoBold.uiFont.withSize(14)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = text.isEmpty
    }
    
    func resetIfNeeded() {
        if notMaxTextLength {
            container.layer.borderColor = Constants.Colors.defaultMessageViewBorderColor.cgColor
            
        } else {
            if highlightsOnMaxLength {
                container.layer.borderColor = Constants.Colors.messageLimitExceedColor.cgColor
            }
        }
        
        textView.text = ""
        textView.sizeToFit()
        
        self.textViewHeight.constraint.update(offset: Constants.Size.defaultHeight)
    }
    
    func updateText(with text: String) {
        textView.text = text
    }
    
    func updateSize() {
//        if (textView.contentSize.height < Constants.Size.maxHeight) {
            let targetSize = CGSize(width: UIScreen.main.bounds.width - 32, height: CGFloat(MAXFLOAT))
            self.textViewHeight.constraint.update(offset: textView.sizeThatFits(targetSize).height)
//        }
    }
}

// MARK: - UITextViewDelegate

extension ProfileEditInputView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty

//        if (textView.contentSize.height < Constants.Size.maxHeight) {
            let targetSize = CGSize(width: UIScreen.main.bounds.width - 32, height: CGFloat(MAXFLOAT))
            self.textViewHeight.constraint.update(offset: textView.sizeThatFits(targetSize).height)
//        }
        
        if highlightsOnMaxLength {
            container.layer.borderColor = notMaxTextLength ? Constants.Colors.defaultMessageViewBorderColor.cgColor : Constants.Colors.messageLimitExceedColor.cgColor
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isEditing = true
        placeholderLabel?.isHidden = !textView.text.isEmpty

        DispatchQueue.main.async { [weak self] in
            let offset = min(textView.contentSize.height, Constants.Size.maxHeight)
//            self?.textViewHeight.constraint.update(offset: offset)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isEditing = false
        placeholderLabel?.isHidden = !textView.text.isEmpty

//        self.textViewHeight.constraint.update(offset: Constants.Size.defaultHeight)
//        self.layoutIfNeeded()
    }
    
}


