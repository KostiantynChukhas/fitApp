

import Foundation

class TextFieldValidator {
    

    public var validations = ValidatorDictionary<ValidationRules>()
    /// Dictionary to hold fields (and accompanying errors) that were unsuccessfully validated.
    public var errors = ValidatorDictionary<ValidationError>()
    /// Dictionary to hold fields by their object identifiers
    private var fields = ValidatorDictionary<Validatable>()
    
    public init(){}
    
    public func registerField(_ field: ValidatableField, rules: [Rule]) {
        validations[field] = ValidationRules(field: field, rules:rules)
        fields[field] = field
    }
    
    public func unregisterField(_ field:ValidatableField) {
        validations.removeValueForKey(field)
        errors.removeValueForKey(field)
    }
    
    func validateAllFields(shouldShowFail: Bool = true, completion: @escaping ([(Validatable, ValidationError)]?)->()) {
        errors = ValidatorDictionary<ValidationError>()
        var outstandingRequests = validations.count
        for (_, rule) in validations {
            rule.validateField(completion: { (validationError) in
                if let error = validationError {
                    self.errors[rule.field] = error
                } else {
                    self.errors.removeValueForKey(rule.field)
                }
                //wait for all fields validations completes
                outstandingRequests -= 1
                if (outstandingRequests == 0) {
                    if self.errors.count > 0 {
                        var dict = [(Validatable, ValidationError)]()
                        self.errors.forEach({ (key, error) in
                            dict.append((self.fields[error.field]!, error))
                            self.fields[error.field]?.errorText = error.errorMessage
                            if shouldShowFail {
                                self.fields[error.field]?.showFail(true)
                            }
                        })
                        completion(dict)
                    } else {
                        completion(nil)
                    }
                }
            })
        }
    }
    
    func validateField(_ field: ValidatableField, shouldShowFail: Bool = true, completion: ((ValidationError?)->())?) {
        if let fieldValidations = validations[field] {
            fieldValidations.validateField(completion: { (error) in
                if let error = error {
                    self.errors[error.field] = error
                    self.fields[error.field]?.errorText = error.errorMessage
                    if shouldShowFail {
                        field.showFail(true)
                    }
                } else {
                    field.showFail(false)
                    self.errors.removeValueForKey(field)
                }
                completion?(error)
            })
        } else {
            completion?(nil)
        }
    }
}
