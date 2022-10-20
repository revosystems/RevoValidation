import UIKit

class RuleRequiredIf : Rule {
    override var errorMessage: String { "Required" }
    
    var other:UITextField
    
    init(other:UITextField){
        self.other = other
    }
    
    override public func isValid(_ text:String) -> Bool {
        (other.text?.count ?? 0) == 0 || text.count > 0
    }
}
