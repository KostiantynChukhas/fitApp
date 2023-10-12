

import Foundation

public protocol RuleProtocol {
  
    var errorMessage: String {get}
   
    func validate(_ value: String, completion: @escaping (Bool, String)->())
}

class Rule: RuleProtocol {
    var errorMessage: String
    
    func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        //
    }
    
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
