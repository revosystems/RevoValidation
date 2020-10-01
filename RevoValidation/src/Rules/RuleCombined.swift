import Foundation
import RevoFoundation

public class RuleCombined : Rule {
 
    var titleTraduction:String
    var combinedRules:[Rule]
    
    override var errorMessage: String{ titleTraduction }
    
    public init(_ rules:[Rule], _ title:String){
        self.combinedRules = rules
        self.titleTraduction = title
    }
    
    override public func isValid(_ text:String) -> Bool {
        combinedRules.contains{ $0.isValid(text) }
    }
}
