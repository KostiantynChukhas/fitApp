//
//  RegistrationViewModel.swift
//  StartProjectsMVVM + C
//

import Foundation
import RxSwift
import RxCocoa

struct SocialLogin {
    var type: TypeRegister
    var token: String
}

class RegistrationViewModel: DeinitAnnouncerType {
    
    fileprivate let coordinator: RegistrationCoordinator
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let emailRelay = BehaviorRelay<String>(value: .empty)
    
    private let passwordRelay = BehaviorRelay<String>(value: .empty)
    
    private let confirmPasswordRelay = BehaviorRelay<String>(value: .empty)
    
    private let errorRelay = BehaviorRelay<String>(value: .empty)
    
    private(set) var didRegistrationRelay = PublishRelay<Void>()
    
    private let retrieveSocialInfoRelay = PublishRelay<SocialLogin>()
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: RegistrationCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    deinit {
        printDeinit(self)
    }
}

extension RegistrationViewModel: ViewModelProtocol {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let confirmPassword: Observable<String>
        let registrationSignal: Observable<Void>
        let facebookSocialSignal: Observable<Void>
        let googleSocialSignal: Observable<Void>
        let appleSocialSignal: Observable<Void>
        let textfieldButtonSignal: Observable<Void>
        let loginSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let error: Driver<String>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupEmailObserving(with: input.email),
            setupPasswordObserving(with: input.password),
            setupConfirmPasswordObserving(with: input.confirmPassword),
            setupRegistrationObserving(with: input.registrationSignal),
            setupRegistrationObserving(with: input.textfieldButtonSignal),
            setupLoginObserving(with: input.loginSignal),
            setupAppleObserving(with: input.appleSocialSignal),
            setupGoogleObserving(with: input.googleSocialSignal),
            setupFacebookObserving(with: input.facebookSocialSignal),
            setupSocialLoginObserving()
        ])
        
        let output = Output(
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false),
            error: errorRelay.asDriver(onErrorJustReturn: .empty)
        )
        
        outputHandler(output)
    }

    private func setupEmailObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: emailRelay)
    }
    
    private func setupPasswordObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: passwordRelay)
    }
    
    private func setupConfirmPasswordObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: confirmPasswordRelay)
    }
    
    private func setupSocialLoginObserving() -> Disposable {
        retrieveSocialInfoRelay
            .withUnretained(self)
            .flatMap { (`self`, data) in
                self.nerworkService.loginFromSocial(requestData: .init(access_token: data.token, type_register: data.type))
            }
            .subscribe(onNext: { response in
                guard let user = response.data else { return }
                SessionManager.shared.setUser(user: user)
                
                if user.isOnboardFinished ?? false {
                    self.route(to: .home)
                } else {
                    self.route(to: .onboardingRegistration(user: user))
                }
            })
    }
    
    private func setupFacebookObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .map { _ in
                self.isLoadingRelay.accept(true)
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                FacebookSignInManager.shared.signIn { [weak self] token in
                    guard let token = token, !token.isEmpty else { return }
                    self?.retrieveSocialInfoRelay.accept(.init(type: .facebook, token: token))
                }
            })
        }
    
    private func setupAppleObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .map { _ in
                self.isLoadingRelay.accept(true)
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                AppleSignInManager().handleAuthorizationAppleID { [weak self] token in
                    guard let token = token, !token.isEmpty else { return }
                    self?.retrieveSocialInfoRelay.accept(.init(type: .apple, token: token))
                }
            })
        }
    
    private func setupGoogleObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .map { _ in
                self.isLoadingRelay.accept(true)
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                GoogleSignInManager.shared.signIn { [weak self] token in
                    guard let token = token, !token.isEmpty else { return }
                    self?.retrieveSocialInfoRelay.accept(.init(type: .google, token: token))
                }
            })
        }
    
    private func setupRegistrationObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { `self`, _ in
                let password = self.passwordRelay.value
                let confirmPassword = self.confirmPasswordRelay.value
                
                if password != confirmPassword {
                    self.errorRelay.accept("Password and confirm password don't match")
                }
                
                return Observable.just(password == confirmPassword)
            }
            .filter { $0 }
            .withUnretained(self)
            .flatMap({ (`self`, _) -> Observable<UserResponseModel> in
                let email = self.emailRelay.value
                let password = self.passwordRelay.value
                return self.nerworkService.registration(requestData: .init(email: email, password: password))
                    .asObservable()
                    .catch { error in
                        AlertManager.showFitAppAlert(title: "Oops, something failed", msg: error.localizedDescription)
                        return .empty()
                    }
            })
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                guard let user = response.data else { return }
                SessionManager.shared.setUser(user: user)
                
                if user.isOnboardFinished ?? false {
                    self.route(to: .home)
                } else {
                    self.route(to: .onboardingRegistration(user: user))
                }
            })
        }
    
    private func setupLoginObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.route(to: .login)
        }
    }
}

// MARK: - Navigation -

extension RegistrationViewModel {
    
    func route(to route: RegistrationCoordinator.Route) {
        coordinator.route(to: route)
    }
}
