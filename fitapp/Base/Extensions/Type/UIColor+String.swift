////
//

import Foundation
import UIKit

public extension UIColor {
    convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()

        guard Scanner(string: hex).scanHexInt64(&int) else {
            return nil
        }

        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)

        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)

        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)

        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    class func generateColorFor(text: String) -> UIColor {
        if text.isEmpty {
            return .clear
        }

        var currentDay = Calendar.current.dateComponents([.day], from: Date()).day ?? 1
        let colorHash = Int(text.hashCode()) / currentDay
        let red = UIColor.red(colorHash)
        let green = UIColor.green(colorHash)
        let blue = UIColor.blue(colorHash)

        return UIColor(red: red, green: green, blue:blue, alpha: 1.0)
    }
    
    // red function, which produces equal output to the Java or Android red function
    class func red(_ value: Int) -> CGFloat {
        CGFloat((Int(value) >> 16) & 0xFF) / 255.0
    }
    
    // green function, which produces equal output to the Java or Android green function
    class func green(_ value: Int) -> CGFloat {
        CGFloat((Int(value) >> 8) & 0xFF) / 255.0
    }
    
    // blue function, which produces equal output to the Java or Android blue function
    class func blue(_ value: Int) -> CGFloat {
        CGFloat(Int(value) & 0xFF) / 255.0
    }
}

public extension String {
    var colorFromHex: UIColor? {
        UIColor(hexString: self)
    }
}

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

extension String {
    // ascii array to map string
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }

    // hashCode function, which produces equal output to the Java or Android hash function
    func hashCode() -> Int32 {
        var h : Int32 = 0
        for i in self.asciiArray {
            h = 31 &* h &+ Int32(i)
        }
        return h
    }
}

