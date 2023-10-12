//
//  Configuration.swift
//  
//

import Foundation

struct Configuration {

    static var shared = Configuration()

    enum Environment: String {

        case development
        case release
        
        var baseUrl: String {
            switch self {
            case .development:  return "https://fitncrazy.pro"
            case .release:      return "https://fitncrazy.pro"
            }
        }
        
        var googleServiceInfoPath: String {
            return Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        }
        
        var isNetfoxEnabled: Bool {
            return true
        }
        
        var networkingEnvironment: NetworkingEnvironment {
            switch self {
            case .development:
                return .development
            case .release:
                return .release
            }
        }
        
        var appVersion: String {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return version
            }
            
            return ""
        }
        
        var buildNumber: String {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        }
        
    }
    
    var environment: Environment {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: "Debug") != nil {
                return .development
            } else if configuration.range(of: "Release") != nil {
                return .release
            }
        }
        return .release
    }

}
