//
//  KeychainStorage.swift
//  fitapp
//
// on 08.05.2023.
//

import Foundation
import KeychainAccess

protocol KeychainKeyType {
    func getRawValue() -> String
}

// MARK: - KeychainKey
enum KeychainKey: String, KeychainKeyType {
    case user = "userKey"
    case token = "tokenKey"
    case uuid = "uuid"
    
    func getRawValue() -> String {
        switch self {
            case .token: return self.rawValue
            case .user: return self.rawValue
            case .uuid: return self.rawValue
        }
    }
}


protocol KeychainStorable: AnyObject {
    func storeObject<T: Codable>(value: T, key: KeychainKeyType)
    func fetchObject<T: Codable>(byKey key: KeychainKeyType) -> T?
    
    func storeString(value: String, key: KeychainKeyType)
    func fetchString(key: KeychainKeyType) -> String?
    
    func removeObject(byKey key: KeychainKeyType)
    func removeSensitiveData()
}

class KeychainStorage<T: Codable> {
    
    // MARK: - Properties
    private let keychain = Keychain()
}

// MARK: - KeychainStorable
extension KeychainStorage: KeychainStorable {
    
    func storeString(value: String, key: KeychainKeyType) {
        do {
            try keychain.set(value, key: key.getRawValue())
        } catch {
            debugPrint("Error in saving data")
        }
    }
    
    func fetchString(key: KeychainKeyType) -> String? {
        do {
            let value = try keychain.get(key.getRawValue())
            return value
        } catch {
            debugPrint("Item not fetched")
        }
        return nil
    }
    
    func storeObject<T: Codable>(value: T, key: KeychainKeyType) {
        do {
            let valudeData = try PropertyListEncoder().encode(value)
            try keychain.set(valudeData, key: key.getRawValue())
        } catch {
            debugPrint("Error in saving data")
        }
    }
    
    func fetchObject<T: Codable>(byKey key: KeychainKeyType) -> T? {
        do {
            guard let data = try keychain.getData(key.getRawValue()) else { return nil }
            let object = try PropertyListDecoder().decode(T.self, from: data)
            return object
        } catch {
            debugPrint("Item not fetched")
        }
        
        return nil
    }
    
    func removeObject(byKey key: KeychainKeyType) {
        do {
            try keychain.remove(key.getRawValue())
        } catch {
            debugPrint("Item not removed")
        }
    }
    
    func removeSensitiveData() {
        [KeychainKey.user, KeychainKey.token]
            .forEach({ removeObject(byKey: $0) })
    }
}
