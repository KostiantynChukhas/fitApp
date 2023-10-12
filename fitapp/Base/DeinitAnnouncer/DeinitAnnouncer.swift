//
//  DeinitAnnouncer.swift
//

import Foundation

public protocol DeinitAnnouncerType: AnyObject {
    func setupDeinitAnnouncer()
}

private var announcerKey = "announcer_key"

// MARK: - DeinitAnnouncerProtocol ext

public extension DeinitAnnouncerType {
    func setupDeinitAnnouncer() {
        let announcer = DeinitAnnouncer(object: self)
        objc_setAssociatedObject(self, &announcerKey, announcer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - DeinitAnnouncer

private class DeinitAnnouncer {
    private let className: String

    init(object: AnyObject) {
        self.className = String(describing: object.self)
    }

    deinit {
        debugPrint("DEINITED: \(className)")
    }
}
