//
//  FitAppTextField.swift
//  StartProjectsMVVM + C
//
import UIKit

@objc protocol FitAppTextFieldViewDelegate {
    @objc optional func textFieldReturn(_ textField: FitAppTextFieldView)
    @objc optional func textFieldAllowBeginEditing(_ textField: FitAppTextFieldView) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: FitAppTextFieldView)
    @objc optional func textFieldDidUpdateHeight(_ textField: FitAppTextFieldView, heightDelta: CGFloat, animationDuration: Double)
    @objc optional func textFieldDidChange(_ textField: FitAppTextFieldView)
    @objc optional func textField(_ textField: FitAppTextFieldView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

class FitAppTextField: UITextField {
    var pastingIsEnabled = true
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.paste(_:)) ||
            action == #selector(self.copy(_:)) ||
            action == #selector(self.cut(_:)) ||
            action == #selector(self.select(_:)) ||
            action == #selector(self.selectAll(_:)) {
            return pastingIsEnabled
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        if pastingIsEnabled {
            return super.selectionRects(for: range)
        } else {
            return []
        }
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        if pastingIsEnabled {
            return super.caretRect(for: position)
        } else {
            return .null
        }
    }
}

class FitAppTextFieldView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var textFieldContentView: UIView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: FitAppTextField!
    @IBOutlet weak var passwordToggleButton: UIButton!
    @IBOutlet weak var trailingErrorConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorContentView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorViewImage: UIView!
    
    weak var delegate: FitAppTextFieldViewDelegate?
    
    var isPasswordTextField: Bool = false
    var pastingIsEnabled: Bool {
        get { return textField.pastingIsEnabled }
        set { textField.pastingIsEnabled = newValue }
    }
    
    private let animationDuration: Double = 0.25
    
    @IBInspectable
    var title: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    
    var text: String? {
        set { setText(newValue) }
        get { return textField.text }
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        set {
            textField.autocapitalizationType = newValue
            textField.reloadInputViews()
        }
        get { return textField.autocapitalizationType }
    }
    
    var isEnabled: Bool {
        set {
            textField.isEnabled = newValue
            textField.textColor = newValue ? Style.Color.textColor.uiColor : .black
        }
        get { return textField.isEnabled }
    }
    
    var isSecureTextEntry: Bool {
        set { textField.isSecureTextEntry = newValue }
        get { return textField.isSecureTextEntry }
    }
    
    var keyboardType: UIKeyboardType {
        set { textField.keyboardType = newValue }
        get { return textField.keyboardType }
    }
    
    var textContentType: UITextContentType {
        set { textField.textContentType = newValue }
        get { return textField.textContentType }
    }
    
    var iconImage: UIImage? {
        didSet {
            if let img = iconImage {
                imageViewContainer.isHidden = false
                imageView.image = img
            } else {
                imageViewContainer.isHidden = true
            }
        }
    }
    
    var bgColor: UIColor? = .white {
        didSet {
            self.textFieldContentView.backgroundColor = bgColor
            errorContentView.backgroundColor = bgColor
        }
    }
    
    override var inputView: UIView? {
        set { textField.inputView = newValue }
        get { return textField.inputView }
    }
    
    var errorText: String? = "Error"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isPasswordTextField {
            setPasswordEyeImage(button: passwordToggleButton)
        } else {
            passwordToggleButton.setImage(nil, for: .normal)
        }
        passwordToggleButton.isHidden = !isPasswordTextField
    }
    
    private func setupUI() {
        nibSetup()
        self.roundCorners(radius: 8)
        self.errorViewImage.roundCorners(radius: 8)
        self.textFieldContentView.roundCorners(radius: 8)
        self.errorHeightConstraint.constant = 1
        self.errorContentView.roundCorners(radius: 8)
        self.textFieldContentView.backgroundColor = bgColor
        self.textFieldContentView.addBorder(color: Style.Color.inactiveBorder.uiColor.withAlphaComponent(0.5), width: 1)
        errorContentView.backgroundColor = bgColor
        autocapitalizationType = .none
        textField.delegate = self
        textField.text = ""
        iconImage = nil
        setupNotifications()
    }
    
    
    private var additionalRightButton: UIButton?
    private var additionalRightButtonClosure: EmptyClosureType?
    
    func addAdditionalRightButtonWith(imageName: String, action: @escaping EmptyClosureType) {
        removeAdditionalRigthButton()
        additionalRightButtonClosure = action
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: #selector(additionalRightButtonAction), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.layoutIfNeeded()
        additionalRightButton = button
    }
    
    func removeAdditionalRigthButton() {
        additionalRightButton?.removeFromSuperview()
    }
        
    @objc private func additionalRightButtonAction() {
        additionalRightButtonClosure?()
    }
    
    @IBAction func passwordToggleButtonAction(_ sender: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        setPasswordEyeImage(button: sender)
        if let textRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument) {
            textField.replace(textRange, withText: textField.text!)
        }
    }
    
    private func setPasswordEyeImage(button: UIButton) {
        let imageName = isSecureTextEntry ? "eye-slash" : "eye"
        button.setImage(.init(named: imageName), for: .normal)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing(ntf:)), name: UITextField.textDidBeginEditingNotification, object: self.textField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing(ntf:)), name: UITextField.textDidEndEditingNotification, object: self.textField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange(ntf:)), name: UITextField.textDidChangeNotification, object: self.textField)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldDidBeginEditing(ntf: NSNotification?) {
        showFail(false)
        updateTitle(isActive: true)
    }
    
    @objc func textFieldDidEndEditing(ntf: NSNotification?) {
        updateTitle(isActive: false)
        delegate?.textFieldDidEndEditing?(self)
    }
    
    @objc func textFieldTextDidChange(ntf: NSNotification?) {
        delegate?.textFieldDidChange?(self)
    }
    
    func setText(_ text: String?) {
        textField.text = text
        updateTitle(isActive: false)
    }
    
    func updateTitle(isActive: Bool) {
        self.textFieldContentView.addBorder(color: Style.Color.inactiveBorder.uiColor, width: 1)
        self.titleLabel.isHidden = isActive
    }
    
    @available(iOS 12.0, *)
    func setPasswordRules(_ rules: UITextInputPasswordRules) {
        textField.passwordRules = rules
    }
    
    func setReturnType(_ type: UIReturnKeyType) {
        textField.returnKeyType = type
    }
    
    func showKeyboard() {
        textField.becomeFirstResponder()
    }
    
    private var needsShowError = false
    func showFail(_ show: Bool) {
        self.errorContentView.backgroundColor = show ? Style.Color.cinnabar.uiColor : .clear
        self.textFieldContentView.addBorder(color: show ? .clear : Style.Color.inactiveBorder.uiColor, width: 1)
        self.errorLabel.text = errorText
        self.passwordToggleButton.isHidden = show
        self.trailingErrorConstraint.constant = show ? -60 : -1
        if needsShowError != show {
            self.needsShowError = show
            delegate?.textFieldDidUpdateHeight?(self, heightDelta: 0, animationDuration: animationDuration)
        }
    }
    
    func errorAnimationCompleted() {
        if !needsShowError {
            self.errorContentView.backgroundColor = .clear
        }
    }
}

extension FitAppTextFieldView: Validatable {
    
    var validationText: String! {
        get {
            return text
        }
    }
}

extension FitAppTextFieldView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldReturn?(self)
        self.endEditing(true)
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let result = self.delegate?.textFieldAllowBeginEditing?(self) {
            return result
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.delegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
