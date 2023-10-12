

import Foundation

public class ValidationRules {
    /// the field of the field
    public var field:ValidatableField
    /// the rules of the field
    public var rules:[RuleProtocol] = []
    
    
    /**
     Initializes `ValidationRule` instance with field, rules, and errorLabel.
     
     - parameter field: field that holds actual text in field.
     - parameter errorLabel: label that holds error label of field.
     - parameter rules: array of Rule objects, which field will be validated against.
     - returns: An initialized `ValidationRule` object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public init(field: ValidatableField, rules:[RuleProtocol]) {
        self.field = field
        self.rules = rules
    }
    
    /**
     Used to validate field against its validation rules.
     - returns: `ValidationError` object if at least one error is found. Nil is returned if there are no validation errors.
     */
    public func validateField(completion: @escaping (ValidationError?)->()) {
        var error: ValidationError?
        
        let group = DispatchGroup()
        
        for i in 0..<self.rules.count {
            if error != nil {
                break
            }
            group.enter()
            let rule = self.rules[i]
            rule.validate(self.field.validationText, completion: { [unowned self] (isValid, message) in
                if !isValid {
                    error = ValidationError(field: self.field, error: rule.errorMessage)
                }
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            completion(error)
        }
    }
}
