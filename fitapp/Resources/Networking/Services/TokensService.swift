//
//  TokensService.swift
//  fitapp
//

import Foundation
import SwiftKeychainWrapper
import JWTDecode

struct TokensResponseModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
    
    let accessToken: String
    let expiresIn: Double?
    let refreshToken: String
}


protocol TokensServiceDelegate: AnyObject {
    func refreshTokens(completion: @escaping ((Bool) -> ()))
}

class TokensService: Service {
    
    struct Keys {
        static let refreshToken = "refreshToken"
        static let email = "email"
        static let password = "password"
        static let tokenFB = "tokenFB"
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    weak var delegate: TokensServiceDelegate?
    
    var accessToken: String? {
        didSet {
            guard let accessToken = accessToken else { return }
            print("Access Token = \(accessToken)")
        }
    }
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: { [weak self] _ in
            self?.refreshTokensByTimer()
        })
    }
    
    func setToken(token: TokensResponseModel){
        self.accessToken = token.accessToken
        self.refreshToken = token.refreshToken
        self.tokenExpiresAt = Date().addingTimeInterval(TimeInterval(token.expiresIn ?? 60))
    }
    
    func seveCredentials(email: String, password: String){
        self.email = email
        self.password = password
    }
    
    func seveTokenFB(tokenFB: String){
        self.tokenFB = tokenFB
    }
    
    var tokenFB: String? {
        get {
            return keychainWrapper.string(forKey: Keys.tokenFB)
        }
        
        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: Keys.tokenFB)
            } else {
                keychainWrapper.removeObject(forKey: Keys.tokenFB)
            }
        }
    }
    
    
    var refreshToken: String? {
        get {
            return keychainWrapper.string(forKey: Keys.refreshToken)
        }
        
        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: Keys.refreshToken)
            } else {
                keychainWrapper.removeObject(forKey: Keys.refreshToken)
            }
        }
    }
    
    var password: String? {
        get {
            return keychainWrapper.string(forKey: Keys.password)
        }
        
        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: Keys.password)
            } else {
                keychainWrapper.removeObject(forKey: Keys.password)
            }
        }
    }
    
    var email: String? {
        get {
            return keychainWrapper.string(forKey: Keys.email)
        }
        
        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: Keys.email)
            } else {
                keychainWrapper.removeObject(forKey: Keys.email)
            }
        }
    }
    
    private var tokenExpiresAt: Date?
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
        tokenExpiresAt = nil
        password = nil
        email = nil
        tokenFB = nil
    }
    
    // MARK: private functions
    
    private func refreshTokensByTimer() {
        guard let tokenExpiresAt = tokenExpiresAt else {
            return
        }
        
        let refreshInterval = Date().addingTimeInterval(60)
        
        print("tokenExpiresAt \(tokenExpiresAt)")
        print("token refreshInterval \(refreshInterval)")
        
        if refreshInterval > tokenExpiresAt {
            print("Refreshing token")
            
            refreshTokens {
                print("Token refreshed status: \($0)")
            }
        }
    }
    
    func refreshTokens(completion: @escaping ((Bool) -> ())) {
//        guard let refreshToken = refreshToken else {
//            completion(false)
//            return
//        }//        let request = RefreshTokensRequest(refreshToken: refreshToken)
//        request.performRequest(to: RefreshTokenModel.self) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .error(message: _):
//                completion(false)
//                break
//            case .success(let newTokens):
//                guard let model = newTokens.token else {
//                    completion(false)
//                    return
//                }//                self.setToken(token: model)
//                completion(true)
//            }
//        }
    }
}
