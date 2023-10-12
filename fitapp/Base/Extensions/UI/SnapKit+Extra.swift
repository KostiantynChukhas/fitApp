//
//  SnapKit+Extra.swift
//  AppDesign
//

import Foundation
import SnapKit

public extension ConstraintMaker {
    @discardableResult
    func fromTheRight(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        left.equalTo(view.snp.right)
    }

    @discardableResult
    func fromTheLeft(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        right.equalTo(view.snp.left)
    }

    @discardableResult
    func above(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        bottom.equalTo(view.snp.top)
    }

    @discardableResult
    func below(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        top.equalTo(view.snp.bottom)
    }
}
