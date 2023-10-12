
import Foundation
import UIKit

open class FitView: UIView {
    // MARK: - Constructor

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupView()
        setupLocalization()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        setupView()
        setupLocalization()
    }

    // MARK: - Fucntions

    open func setupView() {}

    open func setupConstraints() {}

    open func setupLocalization() {}
}
