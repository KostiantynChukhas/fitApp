//
//  IndexPath+extensions.swift//
//

import Foundation

public extension IndexPath {
    
    init(row: Int) {
        self.init(row: row, section: .zero)
    }
    
}
