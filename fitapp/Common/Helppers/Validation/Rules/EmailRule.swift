

import Foundation

class EmailRule: Rule {
    
    public init(message : String = "Invalid email address"){
        super.init(errorMessage: message)
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        let valid = value.isEmail
        completion(valid, valid ? "Field is valid" : errorMessage)
    }
    
}
