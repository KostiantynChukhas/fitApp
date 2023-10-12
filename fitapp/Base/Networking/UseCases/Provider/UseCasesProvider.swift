//
//  UseCasesProvider.swift
//  UseCases
//

import Foundation
import Moya

public class UseCasesProvider {
    // MARK: - Singleton

    public static let shared: UseCasesProviderProtocol = UseCasesProvider()

    // MARK: - Factories
    
    private var environment: NetworkingEnvironment?

    public func setEnvironment(_ environment: NetworkingEnvironment) {
        self.environment = environment
    }

    private lazy var networkingFactory: NetworkingFactory = {
        let factory = NetworkingFactory(environment: environment ?? .release)
        return factory
    }()
    
    // MARK: - Properties

    public var tokenProvider: AuthorizationTokenProvider?
    
    public var uuidProvider: UUIDProvider?

    public var appLanguageProvider: AppLanguageHearderProvider?

    private let printNetworkLogs = true

    // MARK: - UseCases

}

// MARK: - UseCasesProviderProtocol

extension UseCasesProvider: UseCasesProviderProtocol {
    
}
