import UIKit

public class RuleRequiredIf : Rule {
    override var errorMessage: String { "Required as other is present" }
    
    var other:UITextField
    
    public init(other:UITextField){
        self.other = other
    }
    
    override public func isValid(_ text:String) -> Bool {
        (other.text?.count ?? 0) == 0 || text.count > 0
    }
}
