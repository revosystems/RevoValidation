import Foundation
import RevoFoundation

public class RuleCombined : Rule {
 
    var title:String
    var rules:[Rule]
    
    override var errorMessage: String{ title }
    
    public init(_ rules:[Rule], _ title:String){
        self.rules = rules
        self.title = title
    }
    
    override public func isValid(_ text:String) -> Bool {
        rules.contains{ $0.isValid(text) }
    }
}
