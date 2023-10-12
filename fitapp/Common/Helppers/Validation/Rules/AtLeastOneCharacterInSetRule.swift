

import Foundation

class AtLeastOneCharacterInSetRule: Rule {
    
    static var capitalLetter: AtLeastOneCharacterInSetRule {
        AtLeastOneCharacterInSetRule(
            characterSet: CharacterSet.uppercaseLetters,
            message: "Password must have at least one capital letter".localized
        )
    }
    
    static var lowercaseLetter: AtLeastOneCharacterInSetRule {
        AtLeastOneCharacterInSetRule(
            characterSet: CharacterSet.lowercaseLetters,
            message: "Password must have at least one lower case letter".localized
        )
    }
    
    static var digit: AtLeastOneCharacterInSetRule {
        AtLeastOneCharacterInSetRule(
            characterSet: CharacterSet.decimalDigits,
            message: "Password must have at least one digit".localized
        )
    }
    
    static var character: AtLeastOneCharacterInSetRule {
        AtLeastOneCharacterInSetRule(
            characterSet: CharacterSet(charactersIn: "-~!@#$%^&*_+=`|(){}[:;\"'<>,.? ]"),
            message: "Password must have at least one symbol character".localized
        )
    }
    
    private var characterSet: CharacterSet!
    
    public init(characterSet: CharacterSet, message: String = "Field doesn't contain required symbols") {
        super.init(errorMessage: message)
        self.characterSet = characterSet
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        var isValid = false
        for uni in value.unicodeScalars {
            if let uniVal = UnicodeScalar(uni.value), characterSet.contains(uniVal) {
                isValid = true
                break
            }
        }
        completion(isValid, isValid ? "Field is valid" : errorMessage)
    }

}
