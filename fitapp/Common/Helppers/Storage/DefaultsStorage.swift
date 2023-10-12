//
//  DefaultsStorage.swift
//  fitapp
//
// on 08.05.2023.
//

import Foundation

// MARK: - KeychainKey
enum DefaultsKey: String {
    case isLoggedIn
    
    case publicProfile
    case displaymeasurements
    case workoutReminder
    case comments
}

protocol DefaultsStorable: AnyObject {
    associatedtype StorageObject

    func saveObject(object: StorageObject, forKey key: DefaultsKey)
    func fetchObject(forKey key: DefaultsKey) -> StorageObject?
    
    func saveBool(value: Bool, forKey key: DefaultsKey)
    func fetchBool(forKey key: DefaultsKey) -> Bool
    
    func saveInt(value: Int, forKey key: DefaultsKey)
    func fetchInt(forKey key: DefaultsKey) -> Int

    @discardableResult
    func removeObject(forKey key: DefaultsKey) -> StorageObject?
    func removeAll()
}

class DefaultsStorage<T: Codable> {
    
    // MARK: - Properties
    private let storage = UserDefaults.standard
}

// MARK: - KeychainStorable
extension DefaultsStorage: DefaultsStorable {
    
    func save(value: T, forKey key: DefaultsKey) {
        storage.set(value, forKey: key.rawValue)
    }
    
    func fetch(forKey key: DefaultsKey) -> T? {
        return storage.value(forKey: key.rawValue) as? T
    }
    
    func saveBool(value: Bool, forKey key: DefaultsKey) {
        storage.set(value, forKey: key.rawValue)
    }
    
    func saveInt(value: Int, forKey key: DefaultsKey) {
        storage.set(value, forKey: key.rawValue)
    }
    
    func fetchInt(forKey key: DefaultsKey) -> Int {
        return storage.integer(forKey: key.rawValue)
    }
    
    func fetchBool(forKey key: DefaultsKey) -> Bool {
        return storage.bool(forKey: key.rawValue)
    }
    
    func saveDate(value: Date, forKey key: DefaultsKey) {
        storage.set(value, forKey: key.rawValue)
    }
    
    func fetchDate(forKey key: DefaultsKey) -> Date? {
        return storage.value(forKey: key.rawValue) as? Date
    }
    
    func saveObject(object: T, forKey key: DefaultsKey) {
        do {
            let valudeData = try PropertyListEncoder().encode(object)
            storage.setValue(valudeData, forKey: key.rawValue)
        } catch {
            debugPrint("Error in saving data")
        }
        storage.synchronize()
    }

    func fetchObject(forKey key: DefaultsKey) -> T? {
        do {
            guard let data = storage.data(forKey: key.rawValue) else { return nil }
            let object = try PropertyListDecoder().decode(T.self, from: data)
            return object
        } catch {
            debugPrint("Error in fetching data")
        }

        return nil
    }

    @discardableResult
    func removeObject(forKey key: DefaultsKey) -> T? {
        let object = fetchObject(forKey: key)
        storage.removeObject(forKey: key.rawValue)
        return object
    }
    
    func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        storage.removePersistentDomain(forName: domain)
        debugPrint(storage.dictionaryRepresentation())
    }
}
