//
//  ViewCustomizer+UITableViewCell.swift
//  ViewCustomizer
//
//
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UITableViewCell {
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.contentView.backgroundColor = backgroundColor
        return self
    }

    @discardableResult
    func set(selectionStyle: UITableViewCell.SelectionStyle) -> Self {
        view?.selectionStyle = selectionStyle
        return self
    }
}
