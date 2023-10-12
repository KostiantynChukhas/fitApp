

import Foundation

class ConfirmRule: Rule {
    
    private var confirmField: ValidatableField!
    
    public init(confirmField: ValidatableField, message : String = "This field does not match") {
        super.init(errorMessage: message)
        self.confirmField = confirmField
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        let valid = confirmField.validationText == value
        completion(valid, valid ? "Field is valid" : errorMessage)
        return
    }
}
