import Foundation
import RevoFoundation

public class RuleLenght : Rule {
 
    var length = 6
    override var errorMessage: String{
        str(NSLocalizedString("Needs to be at least %d", comment: ""), length)
    }
    
    public init(_ length:Int = 6){
        self.length = length
    }
    
    override public func isValid(_ text:String) -> Bool {
        text.count >= length
    }
}
