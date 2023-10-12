//
//  UUID+Extension.swift
//  fitapp
//
//   on 05.05.2023.
//

import Foundation
import KeychainAccess

extension UUID {
    static var uuid: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}

private class UUIDService {
    private struct Constants {
        static let fakeUUID = "123456789012345678901234"
    }
    
    static let current = UUIDService()
    
    private(set) var uuid: String = Constants.fakeUUID
    
}
