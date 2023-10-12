//
//  ViewCustomizer+UIImageView.swift
//  ViewCustomizer
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIImageView {
    @discardableResult
    func set(image: UIImage?) -> Self {
        view?.image = image
        return self
    }

    @discardableResult
    func set(imageContentMode: UIView.ContentMode) -> Self {
        view?.contentMode = imageContentMode
        return self
    }
}
