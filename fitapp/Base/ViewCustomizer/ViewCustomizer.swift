//
//  ViewCustomizer.swift
//  Extensions
//

import Foundation
import UIKit

public struct ViewCustomizer<ViewType: AnyObject> {
    // MARK: - Properties

    public private(set) weak var view: ViewType?

    // MARK: - Constructor

    public init(view: ViewType) {
        self.view = view
    }
}
