import Foundation

public class RuleContainSpecialChars : Rule {
 
    var characterset:CharacterSet
    override var errorMessage: String { "Needs special chars" }
    
    override public init(){
        characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    }
    
    override public func isValid(_ text:String) -> Bool {
        text.rangeOfCharacter(from: characterset.inverted) != nil        
    }
}
