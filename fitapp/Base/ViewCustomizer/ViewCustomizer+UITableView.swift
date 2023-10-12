//
//  ViewCustomizer+UITableView.swift
//  ViewCustomizer
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UITableView {
    @discardableResult
    func set(dynamicHeight estimatedRowHeight: CGFloat) -> Self {
        return set(estimatedRowHeight: estimatedRowHeight)
            .set(rowHeight: UITableView.automaticDimension)
    }

    @discardableResult
    func set(estimatedRowHeight: CGFloat) -> Self {
        view?.estimatedRowHeight = estimatedRowHeight
        return self
    }

    @discardableResult
    func set(rowHeight: CGFloat) -> Self {
        view?.rowHeight = rowHeight
        return self
    }

    @discardableResult
    func set(separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        view?.separatorStyle = separatorStyle
        return self
    }

    @discardableResult
    func set(separatorInsets: UIEdgeInsets) -> Self {
        view?.separatorInset = separatorInsets
        return self
    }
}
