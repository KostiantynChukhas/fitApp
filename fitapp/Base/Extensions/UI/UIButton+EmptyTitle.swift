//
//  UIButton+EmptyTitle.swift//

import Foundation
import UIKit

public extension UIButton {
    /// Extension for buttons which was created in Stoyboard/xib of XCode 13 and with only image
    func setEmptyTitle() {
        setTitleForAllStates(title: "")
    }
    
    func setTitleForAllStates(title: String) {
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .focused)
        setTitle(title, for: .selected)
    }
    
    func setAttributedTitleForAllStates(title: NSAttributedString) {
        setAttributedTitle(title, for: .normal)
        setAttributedTitle(title, for: .highlighted)
        setAttributedTitle(title, for: .focused)
        setAttributedTitle(title, for: .selected)
    }
    
    func setTitleColorForAllStates(color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
        setTitleColor(color, for: .focused)
        setTitleColor(color, for: .selected)
    }
}
