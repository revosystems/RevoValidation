import UIKit

public class RuleConfirmAge : Rule {
 
    let passwordField:UITextField
    
    override var errorMessage: String{
        "Password does not match"
    }
    
    public init(_ passwordField:UITextField){
        self.passwordField = passwordField
    }
    
    override public func isValid(_ text:String) -> Bool {
        text == passwordField.text
    }
}
