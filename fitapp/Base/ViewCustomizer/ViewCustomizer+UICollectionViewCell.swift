//
//  ViewCustomizer+UICollectionViewCell.swift
//  ViewCustomizer
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UICollectionViewCell {
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.contentView.backgroundColor = backgroundColor
        return self
    }
}
