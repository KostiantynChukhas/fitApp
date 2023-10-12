//
//  LoginViewModel.swift
//  StartProjectsMVVM + C
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: DeinitAnnouncerType {
    
    private var coordinator: LoginCoordinator
    
    // MARK: - Observabled
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let emailRelay = BehaviorRelay<String>(value: .empty)
    
    private let passwordRelay = BehaviorRelay<String>(value: .empty)
    
    private let errorRelay = BehaviorRelay<String>(value: .empty)
    
    private let successAlert = BehaviorRelay<String>(value: .empty)

    private(set) var didLoginRelay = PublishRelay<Void>()
    
    private let retrieveSocialInfoRelay = PublishRelay<SocialLogin>()
    
    private let nerworkService = ServiceFactory.createNetworkService()
    
    init(_ coordinator: LoginCoordinator) {
        self.coordinator = coordinator
        setupDeinitAnnouncer()
    }
    
    func route(to route: LoginCoordinator.Route) {
        coordinator.route(to: route)
    }
}

// MARK: - ViewModelProtocol

extension LoginViewModel: ViewModelProtocol {
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let loginSignal: Observable<Void>
        let forgotPasswordSignal: Observable<Void>
        let registartionSignal: Observable<Void>
        let facebookSocialSignal: Observable<Void>
        let googleSocialSignal: Observable<Void>
        let appleSocialSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let error: Driver<String>
        let successAlert: Driver<String>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupEmailObserving(with: input.email),
            setupPasswordObserving(with: input.password),
            setupLoginObserving(with: input.loginSignal),
            setupForgotPasswordObserving(with: input.forgotPasswordSignal),
            setupRegistrationObserving(with: input.registartionSignal),
            setupAppleObserving(with: input.appleSocialSignal),
            setupGoogleObserving(with: input.googleSocialSignal),
            setupFacebookObserving(with: input.facebookSocialSignal),
            setupSocialLoginObserving()
        ])
        
        let output = Output(
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false),
            error: errorRelay.asDriver(onErrorJustReturn: .empty),
            successAlert: successAlert.asDriver(onErrorJustReturn: .empty)
        )
        
        outputHandler(output)
    }
    
    private func setupEmailObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: emailRelay)
    }
    
    private func setupPasswordObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: passwordRelay)
    }
    
    private func setupForgotPasswordObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.route(to: .forgot)
        }
    }
    
    private func setupRegistrationObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.route(to: .registration)
        }
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
//                    self.successAlert.accept("Success!")
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
    
    private func setupLoginObserving(with signal: Observable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap { (`self`, _) in
                self.isLoadingRelay.accept(true)
                
                let email = self.emailRelay.value
                let password = self.passwordRelay.value
                let data = LoginRequestModel(email: email, password: password)
                
                return self.nerworkService.login(requestData: data).asObservable()
            }
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) })
            .subscribe(onNext: { (`self`, response) in
                guard let user: UserData = response.data else { return }
                SessionManager.shared.setUser(user: user)
                
                if user.isOnboardFinished ?? false {
                    guard user.role == .user else {
                        self.isLoadingRelay.accept(false)
                        return
                    }
                    self.route(to: .home)
                } else {
                    self.route(to: .onboardingRegistration(user: user))
                }
            })
    }
}
