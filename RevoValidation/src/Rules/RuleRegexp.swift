import Foundation

public class RuleRegexp : Rule {
    
    override var errorMessage: String { "Needs to match the required format" }
    
    let regexp:String
    
    init(_ regexp: String) {
        self.regexp = regexp
    }
        
    override public func isValid(_ text:String) -> Bool {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", regexp)
        return emailPred.evaluate(with: text)
    }
}
