import Foundation

public class Rule {
    
    var errors:[String] = []
    var errorMessage:String { "" }
    
    public init() { }
    
    public func isValid(_ text:String) -> Bool {
        return true
    }
}
