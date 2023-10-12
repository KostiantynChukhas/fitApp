//
//  AlertManager.swift
//  fitapp
//

import Foundation
import UIKit

class AlertManager {
    
    static func showDoneAlert(actionHandler: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            let customAlertView = FitDoneAlertView(frame: window.frame)
            customAlertView.configure(actionHandler: actionHandler)
        window.addSubview(customAlertView)
    }
    
    static func showFitAppAlert(title: String? = nil, msg: String? = nil, btn: String = "OK", actionHandler: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            let customAlertView = FitAppAlertView(frame: window.frame)
            customAlertView.configure(title: title, msg: msg, btn: btn, actionHandler: actionHandler)
        window.addSubview(customAlertView)
    }
    
}

