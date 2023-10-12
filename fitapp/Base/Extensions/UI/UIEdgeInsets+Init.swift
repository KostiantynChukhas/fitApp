
import UIKit

public extension UIEdgeInsets {
    init(all: CGFloat) {
        self.init()
        if all != 0 { (top, bottom, left, right) = (all, all, all, all) }
    }

    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init()
        if vertical != 0 { (top, bottom) = (vertical, vertical) }
        if horizontal != 0 { (left, right) = (horizontal, horizontal) }
    }
}
