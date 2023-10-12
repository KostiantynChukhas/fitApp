//
//  UIConfiguration.swift
//


import Foundation
import UIKit

struct UIConfiguration {
    static var main = UIConfiguration()

    let ratio: CGFloat
    let bottomSafeAreaInsets: CGFloat
    let topSafeAreaInsets: CGFloat

    let hasTopNotch: Bool
    let width: CGFloat
    let height: CGFloat

    private init() {
        ratio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        
        bottomSafeAreaInsets = safeAreaInsets.bottom
        topSafeAreaInsets = safeAreaInsets.top
        
        hasTopNotch = UIScreen.main.hasTopNotch
        width = UIScreen.main.bounds.width
        height = UIScreen.main.bounds.height
    }
}

extension UIScreen {

    var hasTopNotch: Bool {
        return bounds.height >= 812
    }
    
}
