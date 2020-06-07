import Foundation

public class RuleContainsNumber : Rule {
 
    var characterset:CharacterSet
    override var errorMessage: String { "Needs to contain a number" }
    
    override public init(){
        characterset = CharacterSet(charactersIn: "0123456789")
    }
    
    override public func isValid(_ text:String) -> Bool {
        let containsNumber = text.rangeOfCharacter(from: characterset) != nil
        if !containsNumber {
            errors = ["Need number"]
        }
        return containsNumber
    }
}
