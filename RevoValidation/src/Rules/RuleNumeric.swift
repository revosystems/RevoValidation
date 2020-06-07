import Foundation

public class RuleNumeric : Rule {
    
    override var errorMessage: String { "Needs to be a number" }
    override public func isValid(_ text:String) -> Bool {        
        Int(text) != nil
    }
    
}
