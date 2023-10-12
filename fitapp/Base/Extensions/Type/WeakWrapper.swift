//
//  WeakWrapper.swift
//  Extensions//

import Foundation

open class WeakWraper<T: AnyObject> {
    weak var value: T?

    init(value: T) {
        self.value = value
    }
}
