//
//  CollectionViewCell.swift
//  AppDesign
//

//

import Foundation
import RxSwift
import UIKit

open class CollectionViewCell: UICollectionViewCell, Reusable {
    // MARK: - Properties

    public lazy var disposeBag = DisposeBag()

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

    override open func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    open func setupView() {}

    open func setupConstraints() {}

    open func setupLocalization() {}
}
