//
//  ServiceFactory.swift
//  fitapp
//
//   on 05.05.2023.
//

import Foundation

class ServiceFactory {
    static func createNetworkService() -> FitappNetworkService {
        let networkingEnvironment = Configuration.shared.environment.networkingEnvironment
        let baseUrl = FitappURLs.getBaseURl(for: networkingEnvironment)
        return FitappNetworkService(baseURL: baseUrl, printRequestLogs: true)
    }
}
