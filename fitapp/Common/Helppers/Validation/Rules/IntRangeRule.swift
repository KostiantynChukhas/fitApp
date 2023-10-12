

import Foundation

class IntRangeRule: Rule {
    
    private var startIndex: Int!
    private var endIndex: Int!
    
    public init(startIndex: Int, endIndex: Int, message: String = "Value is out of range!"){
        super.init(errorMessage: message)
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.errorMessage = message
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        guard let value = Int(value) else {
            completion(false, "Field should be a numeric value")
            return
        }
        let valid = (value >= startIndex && value <= endIndex)
        completion(valid, valid ? "Field is valid" : errorMessage)
        
    }
    
}
