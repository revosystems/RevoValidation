import Foundation

class RuleRequired : Rule {
 
    override var errorMessage: String { "Required" }
    
    override func isValid(_ text:String) -> Bool {
        text.count > 0
    }
}
