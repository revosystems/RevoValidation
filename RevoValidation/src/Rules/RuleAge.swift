import Foundation
import RevoFoundation

public class RuleAge : Rule {
 
    var age = 18
    override var errorMessage: String{
        "Age required: \(length) yo"
    }
    
    public init(_ age:Int = 18){
        self.age = age
    }
    
    override public func isValid(_ text:String) -> Bool {
        guard let dateString = text, let birthDate = Date(string:dateString) else { return false }
        
        return birthDate <= now.subtract(years: age)!
    }
}
