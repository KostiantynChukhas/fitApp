//
//  Refreshable.swift
//  Extensions
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

@objc
public protocol Refreshable: AnyObject {
    /// The refresh control
    var refreshControl: UIRefreshControl? { get set }

    /// the function to call when the user pulls down to refresh
    @objc
    func handleRefresh(_ sender: Any)
}

// MARK: - Refreshable ext where self: UIViewController

public extension Refreshable where Self: UIViewController {
    /// Install the refresh control on the table view
    func installRefreshControl(for scrollView: UIScrollView) {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl = refresh
        scrollView.refreshControl = refresh
    }
}
