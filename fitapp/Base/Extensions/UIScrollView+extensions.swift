//
//  UIScrollViewExtensions.swift
//  
//
//  Created by Nikola Milic on 7/9/20.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        let returnValue = self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
        return returnValue
    }
    
}

extension UIScrollView {
    var isBouncing: Bool {
        var isBouncing = false
        let contentSizeHeight = contentSize.height + 100
        if contentOffset.y >= (contentSizeHeight - bounds.size.height) {
            // bottom bounce
            isBouncing = true
        } else if contentOffset.y <= contentInset.top {
            // top bounce
            isBouncing = true
        }
        
        return isBouncing
    }
}
