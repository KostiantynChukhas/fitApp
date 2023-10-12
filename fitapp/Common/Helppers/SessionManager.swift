//
//  SessionManager.swift
//  fitapp
//
// on 08.05.2023.
//

import Foundation
import Localize_Swift
import RxSwift
import RxCocoa

protocol LoggedInProviderProtocol {
    var isLoggedIn: Bool { get }
}

class SessionManager: LoggedInProviderProtocol {
    static let shared = SessionManager()
    
    public var user: UserData?
    public var token: String?
    public var isLoggedIn = false
    
    public var userId: String { user?.id ?? "" }
    
    public func isOwn(user: UserData) -> Bool {
        return user.id == userId
    }
    
    var userInfoChangedObserver = PublishSubject<UserData>()
    
    private init() {
        
    }
    
    public func startManager() {
        self.user = getUser()
        self.token = getToken()
        self.isLoggedIn = getIsLoggedIn()
    }
    
    // MARK: - Public setters -
    
    public func setUser(user: UserData, needToNotify: Bool = false) {
        self.user = user
        
        if let token = user.token {
            setToken(token: token)
        }
        
        if needToNotify {
            NotificationCenter.post(Notification.Name.User.wasChanged)
        }
        
        KeychainStorage<UserData>().storeObject(value: user, key: KeychainKey.user)
        userInfoChangedObserver.onNext(user)
    }
    
    public func setToken(token: String) {
        self.token = token
        KeychainStorage<String>().storeString(value: token, key: KeychainKey.token)
    }
    
    func setIsLoggedIn(value: Bool) {
        self.isLoggedIn = value
        DefaultsStorage<Bool>().saveBool(value: value, forKey: .isLoggedIn)
        NotificationCenter.post(value ? Notification.Name.Session.loggedIn : Notification.Name.Session.loggedOut)
    }
    
    // MARK: - Pricate getters -
    
    private func getUser() -> UserData? {
        KeychainStorage<UserData>().fetchObject(byKey: KeychainKey.user)
    }
    
    private func getToken() -> String? {
        KeychainStorage<String>().fetchString(key: KeychainKey.token)
    }
    
    private func getIsLoggedIn() -> Bool {
        DefaultsStorage<Bool>().fetchBool(forKey: .isLoggedIn)
    }
    
    public func logout() {
        self.isLoggedIn = false
        
        clearKeychain()
        DefaultsStorage<Bool>().removeObject(forKey: .isLoggedIn)
    }
    
    public func clearKeychain() {
        self.user = nil
        self.token = nil
        KeychainStorage<UserData>().removeSensitiveData()
    }
    
    public func clearUserDefaults() {
        DefaultsStorage<String>().removeAll()
    }
}

// MARK: - AuthorizationTokenProvider

extension SessionManager: AuthorizationTokenProvider {
    func authorizationToken() -> String? {
        getToken()
    }
}

