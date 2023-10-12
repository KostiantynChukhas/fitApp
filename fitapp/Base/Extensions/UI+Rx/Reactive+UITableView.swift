//
//  Reactive+UITableView.swift
//  Extensions//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    import RxCocoa
    import RxSwift

public extension Reactive where Base: UITableView {
    private var delegate: UITableViewDelegateProxy {
        return UITableViewDelegateProxy.proxy(for: base)
    }

    var viewForHeaderInSection: Binder<[Int: UIView?]> {
        Binder(delegate) { del, value in
            del.viewForHeaderInSection.accept(value)
        }
    }

    var viewForFooterInSection: Binder<[Int: UIView?]> {
        Binder(delegate) { del, value in
            del.viewForFooterInSection.accept(value)
        }
    }
}

private final class UITableViewDelegateProxy
: DelegateProxy<UITableView, UITableViewDelegate>
, DelegateProxyType
, UITableViewDelegate {

    public static func registerKnownImplementations() {
        self.register { UITableViewDelegateProxy(parentObject: $0) }
    }

    static func currentDelegate(for object: UITableView) -> UITableViewDelegate? {
        object.delegate
    }

    static func setCurrentDelegate(_ delegate: UITableViewDelegate?, to object: UITableView) {
        object.delegate = delegate
    }

    init(parentObject: UITableView) {
        super.init(
            parentObject: parentObject,
            delegateProxy: UITableViewDelegateProxy.self
        )
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewForHeaderInSection.value[section] ?? nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        viewForFooterInSection.value[section] ?? nil
    }

    fileprivate let viewForHeaderInSection = BehaviorRelay<[Int: UIView?]>(value: [:])
    fileprivate let viewForFooterInSection = BehaviorRelay<[Int: UIView?]>(value: [:])
}

#endif

