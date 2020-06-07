import Foundation

class RuleEmail : Rule {
    
    override var errorMessage: String { "Needs to be an email" }
    
    override func isValid(_ text:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isEmail = emailPred.evaluate(with: text)
        
        return isEmail
    }
}
