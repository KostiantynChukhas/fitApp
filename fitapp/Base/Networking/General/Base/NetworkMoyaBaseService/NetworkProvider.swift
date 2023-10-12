//
//  NetworkProvider.swift
//  Networking
//

import Foundation
import Moya
import RxCocoa
import RxSwift

public final class NetworkProvider: MoyaProvider<TargetHeader> {
    
    private let appCheckToken: AppCheckTokenProtocol
    
    public init(appCheckToken: AppCheckTokenProtocol = AppCheckToken.sharedInstance,
                endpointClosure: @escaping EndpointClosure = MoyaProvider<TargetHeader>.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = MoyaProvider<TargetHeader>.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider<TargetHeader>.neverStub,
                callbackQueue: DispatchQueue? = nil,
                session: Session = MoyaProvider<TargetHeader>.defaultAlamofireSession(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {
        self.appCheckToken = appCheckToken
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
    
    public func request(token: TargetType) -> Single<Response> {
        appCheckToken.targetHeaderObservable(token: token)
            .flatMap { [weak self] token -> Single<Response> in
                guard let self else { return .never() }
                return self.rx.request(token, callbackQueue: nil)
            }
    }
    
    public func requestWithProgress(token: TargetType, callBackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        appCheckToken.targetHeaderObservable(token: token)
            .asObservable()
            .flatMap { [weak self] token -> Observable<ProgressResponse> in
                guard let self else { return .just(ProgressResponse())}
                return self.rx.requestWithProgress(token, callbackQueue: callBackQueue)
            }
    }
}

public extension Reactive where Base: NetworkProvider {
    
    func request(_ token: TargetType) -> Single<Response> {
        base.request(token: token)
    }
    
    func requestWithProgress(_ token: TargetType, callBackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        base.requestWithProgress(token: token, callBackQueue: callBackQueue)
    }
}
