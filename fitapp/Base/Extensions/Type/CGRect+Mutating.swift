
import UIKit

public extension CGRect {
    mutating func set(height: CGFloat) {
        self = CGRect(origin: origin, size: .init(width: width, height: height))
    }
}
