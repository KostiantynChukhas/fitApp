//
//  СustomizerTypeProtocol.swift
//  Extensions
//
//
//

import Foundation
import UIKit

public protocol СustomizerTypeProtocol: AnyObject {}

public extension СustomizerTypeProtocol {
    var customizer: ViewCustomizer<Self> {
        return ViewCustomizer(view: self)
    }
}

extension UIView: СustomizerTypeProtocol {}
extension UIViewController: СustomizerTypeProtocol {}
