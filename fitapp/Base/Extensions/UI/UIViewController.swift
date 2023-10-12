//
//  UIViewController.swift
//  Extensions
//

import UIKit
import RxSwift

public extension UIViewController {
    static func instantiate<T: UIViewController>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T

        return viewController ?? T()
    }
}


extension UIViewController {
    func addCenterActivityView(_ subview: CustomActivityIndicator, color: UIColor = UIColor(red: 0.149, green: 0.055, blue: 0.18, alpha: 0.5)) {
        subview.setup(color: color)
        self.view.addSubview(subview)
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UIView {
    func addCenterActivityView(_ subview: CustomActivityIndicator, color: UIColor = UIColor(red: 0.149, green: 0.055, blue: 0.18, alpha: 0.5)) {
        subview.setup(color: color)
        self.addSubview(subview)
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

fileprivate enum AssociatedKeys {
    static var disposeBag = "ViewController dispose bag associated key"
}

extension ViewController {

    public fileprivate(set) var disposeBag: DisposeBag {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            if let bag = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
                return bag
            } else {
                let bag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, bag, .OBJC_ASSOCIATION_RETAIN)
                return bag
            }
        }
    }
}

