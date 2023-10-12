

import Foundation

class LengthRule: Rule {
    
    private var minLength: Int!
    private var maxLength: Int!
    
    public init(minLength: Int, maxLength: Int, message: String = "Value length is out of range!"){
        super.init(errorMessage: message)
        self.minLength = minLength
        self.maxLength = maxLength
        self.errorMessage = message
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        let valid = (value.count >= minLength && value.count <= maxLength)
        completion(valid, valid ? "Field is valid" : errorMessage)
    }
}


class UsernameLengthRule: Rule {
    
    private var minLength: Int!
    private var maxLength: Int!
    
    public init(minLength: Int, maxLength: Int){
        super.init(errorMessage: "Error!")
        self.minLength = minLength
        self.maxLength = maxLength
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        var valid = true
        if value.count < minLength {
            valid = false
            errorMessage = "Your username is too short".localized
        } else if value.count > maxLength {
            valid = false
            errorMessage = "Your username is too long".localized
        }
        completion(valid, valid ? "Field is valid" : errorMessage)
    }
}

class PasswordLengthRule: LengthRule {
    
    private var minLength: Int!
    private var maxLength: Int!
    
    public init(minLength: Int = 8, maxLength: Int = 16) {
        let message = String(format: "Password must be %d to %d characters".localized, minLength, maxLength)
        super.init(minLength: minLength, maxLength: maxLength, message: message)
        self.minLength = minLength
        self.maxLength = maxLength
        self.errorMessage = message
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        let valid = (value.count >= minLength && value.count <= maxLength)
        completion(valid, valid ? "Field is valid" : errorMessage)
    }
    
}

class PasswordMinLengthRule: Rule {
    
    private var minLength: Int!
    
    public init(minLength: Int = 8) {
        let message = String(format: "Password must be at least %d characters".localized, minLength)
        super.init(errorMessage: message)
        self.minLength = minLength
        self.errorMessage = message
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        let valid = value.count >= minLength
        completion(valid, valid ? "Field is valid" : errorMessage)
    }
    
}
