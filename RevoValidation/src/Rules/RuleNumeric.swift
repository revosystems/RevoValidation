import Foundation

class RuleNumeric : Rule {
    
    override var errorMessage: String { "Needs to be a number" }
    override func isValid(_ text:String) -> Bool {        
        Int(text) != nil
    }
    
}
