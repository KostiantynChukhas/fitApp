//
//  Reactive+UITableView.swift
//  
//
//  Created by Vorko Dmitriy on 07.05.2021.
//  Copyright © 2021 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    func nearBottom(edgeOffset: CGFloat = 20) -> Signal<()> {
        return self.contentOffset.asSignal(onErrorSignalWith: .empty())
            .flatMap { _ in
                return self.base.isNearBottomEdge(edgeOffset: edgeOffset)
                    ? .just(())
                    : .empty()
            }
    }
}
