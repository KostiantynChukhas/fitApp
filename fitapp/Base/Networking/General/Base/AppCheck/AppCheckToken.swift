//
//  AppCheckToken.swift
//  Networking
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseAppCheck

public enum AppCheckTokenError: Error {
    case nullToken
    case error
    case disabled
}

public protocol AppCheckTokenProtocol {
    func targetHeaderObservable(token: TargetType) -> Single<TargetHeader>
    func fetchAppToken(completion: @escaping (String) -> ())
}

public final class AppCheckToken: AppCheckTokenProtocol {
    
    public static let sharedInstance = AppCheckToken()
    
    private var isFetching: Bool = false
    
    private var completions: [(Result<String, Error>) -> Void] = []
    
    private let queue = DispatchQueue.init(label: "io.fitapp.ios.AppCheckToken")
    
    private var appCheckTokenEnabled: Bool = false
    private var appCheckTokenDispatchTime: Int = 5000
    private var appCheckTokenRetryDelay: Int = 3000
    private var isError: Bool = false
    private var timer: Timer?
    private init() { }
    
    public func targetHeaderObservable(token: TargetType) -> Single<TargetHeader> {
        return Single.create {[weak self] observer in
            self?.fetchToken { result in
                var appCheckToken = ""
                if case let .success(data) = result {
                    appCheckToken = data
                }
                let appCheckTokenHeader = TargetHeader(endPoint: token, appCheckToken: appCheckToken)
                observer(.success(appCheckTokenHeader))
            }
            return Disposables.create()
        }
    }
    
    public func fetchAppToken(completion: @escaping (String) -> ()) {
        self.fetchToken { result in
            var appCheckToken = ""
            if case let .success(data) = result {
                appCheckToken = data
            }
            completion(appCheckToken)
        }
    }
    
    private func fetchToken(completion: @escaping (Result<String, Error>) -> Void) {
        queue.async {
            self.completions.append(completion)
            guard self.appCheckTokenEnabled, !self.isError else {
                self.notify(.failure(AppCheckTokenError.disabled))
                return
            }
            guard !self.isFetching else { return }
            self.setupTimer()
            self.isFetching = true
        }
        AppCheck.appCheck().token(forcingRefresh: false) { [weak self] token, error in
            guard let self = self else { return }
            self.isFetching = false
            guard error == nil else {
                self.setupError()
                self.notify(.failure(AppCheckTokenError.error))
                return
            }
            guard let token = token else {
                self.setupError()
                self.notify(.failure(AppCheckTokenError.nullToken))
                return
            }
            self.stopTimer()
            self.notify(.success(token.token))
        }
    }
    
    private func setupError() {
        self.isError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(self.appCheckTokenDispatchTime)) {
            self.isError = false
        }
    }
    
    @objc private func retry() {
        notify(.success(""))
    }
    
    deinit {
        stopTimer()
    }
}
public extension AppCheckToken {
    func update(appCheckTokenEnabled: Bool,
                appCheckTokenDispatchTime: Int,
                appCheckTokenRetryDelay: Int) {
        self.appCheckTokenEnabled = appCheckTokenEnabled
        self.appCheckTokenRetryDelay = appCheckTokenRetryDelay
        self.appCheckTokenDispatchTime = appCheckTokenDispatchTime
    }
}
private extension AppCheckToken {
    
    func setupTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(appCheckTokenRetryDelay/1000),
                                     target: self,
                                     selector: #selector(retry),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    func stopTimer() {
        queue.async {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    func notify(_ value: Result<String, Error>) {
        queue.async {
            self.completions.forEach { $0(value) }
            self.completions.removeAll()
        }
    }
}
