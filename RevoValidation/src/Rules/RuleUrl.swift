import Foundation

public class RuleUrl : Rule {

    override var errorMessage: String { "Needs to be an url" }

    override public func isValid(_ text:String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}"
        let urlPred = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        
        return urlPred.evaluate(with: text)
    }
}
