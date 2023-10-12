//
//  ForgotPasswordViewController.swift
//  fitapp
//

import UIKit

class ForgotPasswordViewController: ViewController<ForgotPasswordViewModel> {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: FitAppTextFieldView!
    @IBOutlet weak var sendButton: RoundedButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var validator = TextFieldValidator()

    override func setupView() {
        super.setupView()
        setupTextFields()
    }

    override func setupLocalization() {
        
    }
    
    override func setupInput(input: ForgotPasswordViewModel.Output) {
        
    }
    
    override func setupOutput() {
        let input = ForgotPasswordViewModel.Input(
            backSignal: backButton.rx.tap.asObservable(),
            email: emailTextField.textField.rx.text.asObservable().ignoreNil(),
            sendSignal: sendButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    private func setupTextFields() {
        validator.registerField(emailTextField, rules: [RequiredRule(), EmailRule()])
        
        emailTextField.textContentType = .username
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.setReturnType(.done)
        emailTextField.textField.placeholder = "Enter your email"
    }
    
    private func checkValidFields(completion: ((Bool) -> ())? = nil) {
        view.endEditing(true)
        validator.validateAllFields { [weak self] (errorsDictionary) in
            if let errDict = errorsDictionary, errDict.count > 0 {
                let validatableFields = errDict.map { $0.0 }
                if let errorMessage = validatableFields.first?.errorText, !errorMessage.isEmpty {
                    self?.warningLabel.text = errorMessage
                    completion?(false)
                }
            } else {
                completion?(true)
            }
        }
    }
    
}

// MARK: - FitAppTextFieldViewDelegate

extension ForgotPasswordViewController: FitAppTextFieldViewDelegate {
    func textFieldAllowBeginEditing(_ textField: FitAppTextFieldView) -> Bool {
        return true
    }
    
    func textFieldReturn(_ textField: FitAppTextFieldView) {
        switch textField {
        case emailTextField:
            break
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: FitAppTextFieldView) {
        validator.validateField(textField) { [weak self] errorMessage in
            self?.warningLabel.text = errorMessage?.errorMessage
        }
    }
    
    func textFieldDidUpdateHeight(_ textField: FitAppTextFieldView, heightDelta: CGFloat, animationDuration: Double) {
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        } completion: { completed in
            if completed {
                textField.errorAnimationCompleted()
            }
        }
    }
    
    func textFieldDidChange(_ textField: FitAppTextFieldView) {
        setSendButtonEnable()
    }
    
    private func setSendButtonEnable() {
        validator.validateAllFields(shouldShowFail: false) { [weak self] errors in
//            self?.btnSend.isEnabled = (errors?.count ?? 0) == 0
        }
    }
}

