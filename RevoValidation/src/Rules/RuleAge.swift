import Foundation
import RevoFoundation

public class RuleAge : Rule {
 
    var age = 18
    lazy var now:Date = { Date() }()
    
    override var errorMessage: String{        
        str(NSLocalizedString("Age required: %d yo", comment: ""), age)
    }
    
    public init(_ age:Int = 18){
        self.age = age
    }
    
    override public func isValid(_ text:String) -> Bool {
        guard let birthDate = Date(string:text) else { return false }
        
        return birthDate <= now.subtract(years: age)!
    }
}
