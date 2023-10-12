//
//  NetworkingFactory.swift
//  Networking
//

import Foundation

public final class NetworkingFactory {
    // MARK: - Properties

    private var environment: NetworkingEnvironment
    // MARK: - Constructor

    public init(environment: NetworkingEnvironment) {
        self.environment = environment
    }
    
    func change(environment: NetworkingEnvironment) {
        self.environment = environment
    }

    // MARK: - Functions

}
