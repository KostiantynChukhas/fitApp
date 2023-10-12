//
//  ViewCustomizer+ReusableTableHeaderFooterView.swift
//  ViewCustomizer
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UITableViewHeaderFooterView {
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.tintColor = .clear
        view?.contentView.backgroundColor = backgroundColor
        return self
    }
}
