//
//  ViewCustomizer+UIScrollView.swift
//  ViewCustomizer
//
//
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIScrollView {
    @discardableResult
    func set(bounces: Bool) -> Self {
        view?.bounces = bounces
        return self
    }

    @discardableResult
    func set(
        contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior
    ) -> Self {
        view?.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        return self
    }

    @discardableResult
    func set(contentInset: UIEdgeInsets) -> Self {
        view?.contentInset = contentInset
        return self
    }

    @discardableResult
    func set(showsVerticalScrollIndicator: Bool) -> Self {
        view?.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }

    @discardableResult
    func set(showsHorizontalScrollIndicator: Bool) -> Self {
        view?.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }

    @discardableResult
    func set(showScrollIndicators: Bool) -> Self {
        return set(showsVerticalScrollIndicator: showScrollIndicators)
            .set(showsHorizontalScrollIndicator: showScrollIndicators)
    }

    @discardableResult
    func set(keyboardDismissMode: UIScrollView.KeyboardDismissMode) -> Self {
        view?.keyboardDismissMode = keyboardDismissMode
        return self
    }

    @discardableResult
    func set(isScrollEnabled: Bool) -> Self {
        view?.isScrollEnabled = isScrollEnabled
        return self
    }

    @discardableResult
    func set(contentSize: CGSize) -> Self {
        view?.contentSize = contentSize
        return self
    }

    @discardableResult
    func set(isPagingEnabled: Bool) -> Self {
        view?.isPagingEnabled = isPagingEnabled
        return self
    }
}
