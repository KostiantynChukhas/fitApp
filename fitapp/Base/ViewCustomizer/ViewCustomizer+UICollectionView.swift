//
//  ViewCustomizer+UICollectionView.swift
//  AppDesign
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UICollectionView {
    @discardableResult
    func set(allowsMultipleSelection: Bool) -> Self {
        view?.allowsMultipleSelection = allowsMultipleSelection
        return self
    }
}
