//
//  ViewCustomizer+UIStackView.swift
//  ViewCustomizer
//
//
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIStackView {
    @discardableResult
    func set(distribution: UIStackView.Distribution) -> Self {
        view?.distribution = distribution
        return self
    }
    
    @discardableResult
    func set(spacing: CGFloat) -> Self {
        view?.spacing = spacing
        return self
    }
    
    @discardableResult
    func set(alignment: UIStackView.Alignment) -> Self {
        view?.alignment = alignment
        return self
    }
}
