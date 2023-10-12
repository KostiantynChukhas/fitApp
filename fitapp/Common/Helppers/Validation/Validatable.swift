

import Foundation

public typealias ValidatableField = AnyObject & Validatable

public protocol Validatable {
    
    var validationText: String! {
        get
    }
    
    var errorText: String? {
        get set
    }
    
    func showFail(_ show: Bool)
    
}
