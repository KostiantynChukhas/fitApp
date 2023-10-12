//
//  RegistrationViewController.swift
//  StartProjectsMVVM + C
//

import UIKit
import RxCocoa
import RxSwift

class RegistrationViewController: ViewController<RegistrationViewModel> {
    
    @IBOutlet weak var tfEmail: FitAppTextFieldView!
    @IBOutlet weak var tfPassword: FitAppTextFieldView!
    @IBOutlet weak var tfConfirmPassword: FitAppTextFieldView!
    @IBOutlet weak var btnRegister: RoundedButton!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    private var validator = TextFieldValidator()
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        setupTextFields()
        setupButtons()
        addCenterActivityView(activityIndicator)
    }
    
    private func setupTextFields() {
        validator.registerField(tfEmail, rules: [RequiredRule(), EmailRule()])
        validator.registerField(tfPassword, rules: [RequiredRule()])
        validator.registerField(tfConfirmPassword, rules: [RequiredRule()])
        
        tfEmail.textContentType = .username
        tfEmail.delegate = self
        tfEmail.keyboardType = .emailAddress
        tfEmail.setReturnType(.next)
        tfEmail.textField.placeholder = "Email"
        
        tfPassword.textContentType = .password
        tfPassword.delegate = self
        tfPassword.setReturnType(.next)
        tfPassword.isSecureTextEntry = true
        tfPassword.isPasswordTextField = true
        tfPassword.textField.placeholder = "Password"
        
        tfConfirmPassword.textContentType = .password
        tfConfirmPassword.delegate = self
        tfConfirmPassword.setReturnType(.done)
        tfConfirmPassword.isSecureTextEntry = true
        tfConfirmPassword.isPasswordTextField = true
        tfConfirmPassword.textField.placeholder = "Confirm password"
    }
    
    private func setupButtons() {
        btnRegister.isEnabled = false
        
        [btnFb, btnGoogle, btnApple] .forEach {
            $0?.roundCorners(radius: 8)
            $0?.addBorder(color: Style.Color.inactiveBorder.uiColor.withAlphaComponent(0.5), width: 1)
        }
    }
    
    private func attemptToLogin() {
        checkValidFields { [weak self] isOk in
            if isOk {
                self?.view.resignFirstResponder()
            }
        }
    }
    
    private func checkValidFields(completion: ((Bool) -> ())? = nil) {
        view.endEditing(true)
        validator.validateAllFields { [weak self] (errorsDictionary) in
            if let errDict = errorsDictionary, errDict.count > 0 {
                let validatableFields = errDict.map { $0.0 }
                if let errorMessage = validatableFields.first?.errorText, !errorMessage.isEmpty {
                    self?.lblWarning.text = errorMessage
                    completion?(false)
                }
            } else {
//              self?.registration()
                completion?(true)
            }
        }
    }
    
    override func setupOutput() {
        let textFieldDoneSignal = tfConfirmPassword.textField.rx.controlEvent(.editingDidEndOnExit).mapToVoid()
        
        let input = RegistrationViewModel.Input(
            email: tfEmail.textField.rx.text.ignoreNil(),
            password: tfPassword.textField.rx.text.ignoreNil(),
            confirmPassword: tfConfirmPassword.textField.rx.text.ignoreNil(),
            registrationSignal: btnRegister.rx.tap.asObservable(),
            facebookSocialSignal: btnFb.rx.tap.asObservable(),
            googleSocialSignal: btnGoogle.rx.tap.asObservable(),
            appleSocialSignal: btnApple.rx.tap.asObservable(),
            textfieldButtonSignal: textFieldDoneSignal,
            loginSignal: btnLogin.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: RegistrationViewModel.Output) {
        disposeBag.insert([
            setupActivityIndicatorObserving(with: input.isLoading),
            setupErrorObserver(with: input.error)
        ])
    }
    
    private func setupErrorObserver(with signal: Driver<String>) -> Disposable {
        signal.drive { [weak self]  in
            self?.lblWarning.text = $0
        }
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
}

extension RegistrationViewController: FitAppTextFieldViewDelegate {
    func textFieldAllowBeginEditing(_ textField: FitAppTextFieldView) -> Bool {
        return true
    }
    
    func textFieldReturn(_ textField: FitAppTextFieldView) {
        switch textField {
        case tfEmail:
            tfPassword.showKeyboard()
        case tfPassword:
            tfConfirmPassword.showKeyboard()
        case tfConfirmPassword:
            attemptToLogin()
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: FitAppTextFieldView) {
        validator.validateField(textField) { [weak self] errorMessage in
            self?.lblWarning.text = errorMessage?.errorMessage
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
        setLoginButtonEnable()
    }
    
    private func setLoginButtonEnable() {
        validator.validateAllFields(shouldShowFail: false) { [weak self] errors in
            self?.btnRegister.isEnabled = (errors?.count ?? 0) == 0
        }
    }
}
