import Foundation

class RuleContainsNumber : Rule {
 
    var characterset:CharacterSet
    override var errorMessage: String { "Needs to contain a number" }
    
    override init(){
        characterset = CharacterSet(charactersIn: "0123456789")
    }
    
    override func isValid(_ text:String) -> Bool {
        let containsNumber = text.rangeOfCharacter(from: characterset) != nil
        if !containsNumber {
            errors = ["Need number"]
        }
        return containsNumber
    }
}
