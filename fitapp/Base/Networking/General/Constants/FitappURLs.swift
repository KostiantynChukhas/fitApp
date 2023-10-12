//
//  FitappURLs.swift
//  Networking
//

import Foundation

public enum NetworkingEnvironment {
    case development
    case release
}

public enum FitappURLs: String {
    case prodUrl = "https://fitncrazy.pro"
    case developUrl = "https://dev.fitncrazy.pro"

    public var url: URL {
        guard let url = URL(string: rawValue) else {
            fatalError("Failed attempt create fitapp URL instance \(rawValue)")
        }
        return url
    }
    
    static func getBaseURl(for env: NetworkingEnvironment) -> URL {
        switch env {
        case .development:
            return FitappURLs.prodUrl.url
        case .release:
            return FitappURLs.prodUrl.url
        }
    }
}
