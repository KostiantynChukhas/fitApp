

import Foundation

class CharacterSetRule: Rule {
    
    private var characterSet: CharacterSet!
    
    public init(characterSet: CharacterSet, message: String = "Field contains invalid symbols") {
        super.init(errorMessage: message)
        self.characterSet = characterSet
    }
    
    override func validate(_ value: String, completion: @escaping (Bool, String) -> ()) {
        for uni in value.unicodeScalars {
            guard let uniVal = UnicodeScalar(uni.value), characterSet.contains(uniVal) else {
                completion(false, errorMessage)
                return
            }
        }
        completion(true, "Field is valid")
    }

}
