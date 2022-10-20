import Foundation

public class RuleUnique : Rule {
    
    var existing:[String]
    
    override var errorMessage: String { "Needs to be unique" }
    
    public init(existing:[String]){
        self.existing = existing
    }
    
    override public func isValid(_ text:String) -> Bool {
        !existing.contains(text)
    }
    
}
