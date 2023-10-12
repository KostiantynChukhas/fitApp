//
//  HomeTabBarController.swift
//  fitapp
//
//  Created by on 14.05.2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    private var viewModel: HomeTabBarViewModel!
    lazy var customTabBar = CustomTabBar()
    lazy var bottomView = UIView()
    
    private var controllers: [(TabBarType, UIViewController)] = []
    private var currentPageIndex = 0
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    // Layout
    var tabBarHeight: CGFloat { tabBar.frame.size.height }
    
    
    // MARK: - Setup Functions
    convenience init(viewModel: HomeTabBarViewModel) {
        self.init()
        self.viewModel = viewModel
        setup()
    }
    
    private func setup() {
        setupConstraints()
        setupView()
        setupOutput()
    }
    
    private func setupConstraints() {
        view.addSubview(customTabBar)
        view.addSubview(bottomView)
        
        customTabBar.snp.makeConstraints { [unowned self] in
            $0.height.equalTo(tabBarHeight).priority(.high)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSafe(of: self).offset(10)
        }
        
        bottomView.snp.makeConstraints { [unowned self] in
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(customTabBar.snp.bottom)
        }
        
    }
    
    private func setupView() {
        tabBar.barTintColor = .clear
        tabBar.tintColor = .clear
        tabBar.backgroundColor = .clear
        tabBar.isHidden = false
        tabBar.isOpaque = false
        bottomView.backgroundColor = Style.Color.borderColor.uiColor
        customTabBar.select(index: .zero, animated: false)
    }
    
    private func setupOutput() {
        let input = HomeTabBarViewModel.Input(
            tabTypeTapEvent: customTabBar.tapEvent,
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupInput(input: HomeTabBarViewModel.Output) {
        disposeBag.insert([
            setupSelectTabTypeObserving(with: input.selectTabType),
        ])
    }
    
    private func setupSelectTabTypeObserving(with signal: Driver<TabBarType>) -> Disposable {
        signal
            .drive(with: self) {`self`, tabType in
                guard let tabIndex = self.indexOf(tabType: tabType) else { return }
                self.currentPageIndex = tabIndex
                self.updateSelectedIndex()
            }
    }
}

extension HomeTabBarController {
    
    private func indexOf(tabType: TabBarType) -> Int? {
        controllers.firstIndex(where: {$0.0 == tabType})
    }
    
    func addViewController(_ viewController: UIViewController, tabType: TabBarType) {
        let tabInfo = (tabType, viewController)
        if let tabIndex = indexOf(tabType: tabType) {
            controllers[tabIndex] = tabInfo
        } else {
            controllers.append(tabInfo)
        }
    }
    
    func reload() {
        viewControllers = [pageViewController]
        updateSelectedIndex()
    }
    
    private func updateSelectedIndex() {
        guard currentPageIndex < controllers.count else { return }
        pageViewController.setViewControllers([controllers[currentPageIndex].1],
                                              direction: .forward,
                                              animated: false)
    }
}

extension UITabBarController {
    func setHidden(_ value: Bool) {
        guard let controller = self as? HomeTabBarController else { return }
        UIView.animate(withDuration: 0.25, animations: {
            controller.customTabBar.alpha = value ? 0: 1
            controller.bottomView.alpha = value ? 0: 1
            
        }, completion: { [weak self] _ in
            self?.tabBar.isHidden = value
        })
    }
}
