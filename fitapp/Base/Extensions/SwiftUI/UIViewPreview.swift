//
//  UIViewPreview.swift
//  Extensions//
//

import Foundation
#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    public typealias UIKitPreviewContainer = UIView

    @available(iOS 13, *)
    public struct UIViewPreview: UIViewRepresentable {
        private var container = UIView()

        public init(_ builder: @escaping (UIKitPreviewContainer) -> UIView) {
            self.container = builder(container)
        }

        // MARK: - UIViewRepresentable

        public func makeUIView(context: Context) -> UIView {
            return container
        }

        public func updateUIView(_ view: UIView, context: Context) {
            container.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            container.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
    }
#endif
