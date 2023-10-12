//
//  UIVIew+SubviewsSearching.swift
//  Extensions
//

import Foundation
import UIKit

public extension UIView {
    func getAllSubviews<T: UIView>() -> [T] {
        return subviews.flatMap { subView -> [T] in
            var result = subView.getAllSubviews() as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
