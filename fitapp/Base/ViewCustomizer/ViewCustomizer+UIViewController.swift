//
//  ViewCustomizer+UIViewController.swift
//  ViewCustomizer
//
//
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIViewController {
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.view.backgroundColor = backgroundColor
        return self
    }
}
