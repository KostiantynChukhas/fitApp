//
//  Encodable+Extra.swift
//  Networking
//

import Foundation

public extension Encodable {
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch {
            let desc = "Failed attempt to convert Encodable object to [String: Any] dictionary."
            debugPrint("\(desc) \(error.localizedDescription)")
            return nil
        }
    }
    
    func toJsonString() -> String? {
        if let data = try? JSONEncoder().encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func asDictionaryOrEmpty() -> [String: Any] {
        asDictionary() ?? [:]
    }
    
    func flattenDictionary() -> [String: Any] {
        func flattenRec(output: inout [String: Any], keyPath: String, value: Any) {
            if let dict = value as? [String: Any] {
                dict.forEach { key, value in flattenRec(output: &output, keyPath: key, value: value) }
            } else {
                output[keyPath] = value
            }
        }
        
        var outputDict = [String: Any]()
        let dictionary = asDictionary() ?? [:]
        dictionary.forEach { key, value in flattenRec(output: &outputDict, keyPath: key, value: value) }
        
        return outputDict
    }
    
    static func fromJsonString<T: Codable>(_ str: String) -> T? {
        if let data = str.data(using: .utf8) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    func convertToData() -> Data? {
        if let data = try? JSONEncoder().encode(self) {
            return data
        }
        return nil
    }
}

extension Data {
    public func convertToDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
