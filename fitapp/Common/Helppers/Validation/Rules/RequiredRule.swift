

import Foundation

class RequiredRule: Rule {
    
    public override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        let valid = !value.isEmpty
        completion(valid, valid ? "Field is valid" : errorMessage)
    }
    
    public init(message: String = "This field is required") {
        super.init(errorMessage: message)
        self.errorMessage = message
    }
    
    open func validate(_ value: String) -> Bool {
        return !value.isEmpty
    }
    
}
