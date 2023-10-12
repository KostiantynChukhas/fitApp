//
//  Notification+extensions.swift
//  fitapp
//
// on 08.05.2023.
//

import Foundation

typealias NC = NotificationCenter

extension Notification.Name {
    
    public struct Session {
        public static let loggedIn = Notification.Name(rawValue: "ios.Notification.Name.Session.loggedIn")
        public static let loggedOut = Notification.Name(rawValue: "ios.Notification.Name.Session.loggedOut")
        public static let expired = Notification.Name(rawValue: "ios.Notification.Name.Session.expired")
    }
    
    public struct User {
        public static let followDidChange = Notification.Name(rawValue: "ios.Notification.Name.User.followDidChange")
        public static let wasChanged = Notification.Name(rawValue: "ios.Notification.Name.User.userWasChanged")
    }
    
}

extension NotificationCenter {

    static func post(_ name: NSNotification.Name, info: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: info)
    }
}
