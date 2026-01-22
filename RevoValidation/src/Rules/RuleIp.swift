import Foundation

public class RuleIp : Rule {
    
    override var errorMessage: String { "Needs to be a valid IP address" }
    
    override public func isValid(_ text:String) -> Bool {
        // IPv4 regex: validates octets from 0-255
        let ipv4Pattern = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        let ipPred = NSPredicate(format:"SELF MATCHES %@", ipv4Pattern)
        
        return ipPred.evaluate(with: text)
    }
}
