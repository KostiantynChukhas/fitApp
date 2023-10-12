//
//  LoginViewController.swift
//  StartProjectsMVVM + C
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class LoginViewController: ViewController<LoginViewModel> {
    
    @IBOutlet weak var tfEmail: FitAppTextFieldView!
    @IBOutlet weak var tfPassword: FitAppTextFieldView!
    @IBOutlet weak var btnLogin: RoundedButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    private var validator = TextFieldValidator()
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextFields()
        
        addCenterActivityView(activityIndicator)
    }
    
    private func setupTextFields() {
        validator.registerField(tfEmail, rules: [RequiredRule(), EmailRule()])
        validator.registerField(tfPassword, rules: [RequiredRule()])
        
        tfEmail.textContentType = .username
        tfEmail.delegate = self
        tfEmail.keyboardType = .emailAddress
        tfEmail.setReturnType(.next)
        tfEmail.textField.placeholder = "Enter your email"
        
        tfPassword.textContentType = .password
        tfPassword.delegate = self
        tfPassword.setReturnType(.done)
        tfPassword.isSecureTextEntry = true
        tfPassword.isPasswordTextField = true
        tfPassword.textField.placeholder = "Enter your password"
        
        if Platform.isSimulator {
            tfEmail.text = "test@gmail.com"
            tfPassword.text = "testtest"
        }
    }
    
    private func setupButtons() {
        
        [btnFb, btnGoogle, btnApple] .forEach {
            $0?.roundCorners(radius: 8)
            $0?.addBorder(color: Style.Color.inactiveBorder.uiColor.withAlphaComponent(0.5), width: 1)
        }
    }
    
    private func attemptToLogin() {
        checkValidFields { isOk in
            if isOk {
                // go to login
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
                completion?(true)
            }
        }
    }
    
    override func setupView() {
        
    }
    
    override func setupLocalization() {
        if Configuration.shared.environment == .development {
            tfEmail.text = "test@gmail.com"
            tfPassword.text = "testtest"
        }
    }
    
    override func setupOutput() {
        let input = LoginViewModel.Input(
            email: tfEmail.textField.rx.text.ignoreNil(),
            password: tfPassword.textField.rx.text.ignoreNil(),
            loginSignal: btnLogin.rx.tap.asObservable(),
            forgotPasswordSignal: forgotPasswordButton.rx.tap.asObservable(),
            registartionSignal: registrationButton.rx.tap.asObservable(),
            facebookSocialSignal: btnFb.rx.tap.asObservable(),
            googleSocialSignal: btnGoogle.rx.tap.asObservable(),
            appleSocialSignal: btnApple.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: LoginViewModel.Output) {
        disposeBag.insert([
            setupActivityIndicatorObserving(with: input.isLoading),
            successAlertObserving(with: input.successAlert)
        ])
    }
    
    private func successAlertObserving(with signal: Driver<String>) -> Disposable {
        signal.drive(onNext: { message in
            guard !message.isEmpty else { return }
            AlertManager.showFitAppAlert(msg: message)
        })
        
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
}

extension LoginViewController: FitAppTextFieldViewDelegate {
    func textFieldAllowBeginEditing(_ textField: FitAppTextFieldView) -> Bool {
        return true
    }
    
    func textFieldReturn(_ textField: FitAppTextFieldView) {
        switch textField {
        case tfEmail:
            tfPassword.showKeyboard()
        case tfPassword:
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
            self?.btnLogin.isEnabled = (errors?.count ?? 0) == 0
        }
    }
}
