//
//  CustomTabBar.swift
//  fitapp
//
//  Created by on 12.05.2023.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class CustomTabBar: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var homeItem: TabBarItemView!
    @IBOutlet weak var communityItem: TabBarItemView!
    @IBOutlet weak var libraryItem: TabBarItemView!
    @IBOutlet weak var analyticsItem: TabBarItemView!
    @IBOutlet weak var profileItem: TabBarItemView!
    
    private let buttonTapEvent: PublishSubject<TabBarType> = .init()
    var tapEvent: Observable<TabBarType> { buttonTapEvent }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layoutIfNeeded()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
    private func setupView() {
        [homeItem, communityItem, libraryItem, analyticsItem, profileItem].forEach {
            $0?.delegate = self
        }
    }
    
    func select(index: Int, animated: Bool = false) {
        let items = [homeItem, communityItem, libraryItem, analyticsItem, profileItem]
        items.forEach {
            $0?.select(false, animated: animated)
        }
        items[index]?.select(true, animated: animated)
    }
}

// MARK: - TabBarItemViewDelegate
 
extension CustomTabBar: TabBarItemViewDelegate {
    func didClicked(item: TabBarItemView) {
        let items = [homeItem, communityItem, libraryItem, analyticsItem, profileItem]
        
        items.forEach {
            $0?.select(false, animated: false)
        }
        
        item.select(true, animated: true)
        buttonTapEvent.onNext(TabBarType(rawValue: items.firstIndex(of: item) ?? .zero) ?? .home)
    }
}
