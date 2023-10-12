

import Foundation

public class ValidationError: NSObject {
    /// the Validatable field of the field
    public let field: ValidatableField
    /// the error message of the field
    public let errorMessage:String
    
    /**
     Initializes `ValidationError` object with a field, errorLabel, and errorMessage.
     - parameter field: Validatable field that holds field.
     - parameter errorLabel: UILabel that holds error label.
     - parameter errorMessage: String that holds error message.
     - returns: An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public init(field:ValidatableField, error:String){
        self.field = field
        self.errorMessage = error
    }
}
