//
//  NotificationCenter+KeyboardHeight.swift
//  Extensions//
//

import Foundation
import RxSwift

public extension Reactive where Base: NotificationCenter {
    func keyboardHeightNotifier(key: String = UIResponder.keyboardFrameBeginUserInfoKey) -> Observable<CGFloat> {
        let notificationCenter = NotificationCenter.default
        return Observable
            .from([
                notificationCenter.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        guard
                            let userInfo = notification.userInfo,
                            let keyboardFrameValue = userInfo[key] as? NSValue
                        else {
                            return 0
                        }
                        let keyboardFrame = keyboardFrameValue.cgRectValue
                        return keyboardFrame.height
                    },

                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        0
                    }
            ])
            .merge()
    }
}
