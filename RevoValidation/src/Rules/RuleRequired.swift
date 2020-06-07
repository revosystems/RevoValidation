import Foundation

public class RuleRequired : Rule {
 
    override var errorMessage: String { "Required" }
    
    override public func isValid(_ text:String) -> Bool {
        text.count > 0
    }
}
