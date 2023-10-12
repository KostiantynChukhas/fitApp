//
//  CALayer+Extra.swift
//  Extensions
//

import UIKit

public extension CALayer {
    /// Change layers without animation
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}
