import UIKit
import RevoFoundation

public struct Rules : ExpressibleByStringLiteral {
    let rules:[Rule]
    
    public init(stringLiteral value: String) {
        self.rules = value.explode("|").compactMap {
            let params = $0.explode(":")
            switch params.first! {
            case "required"             : return RuleRequired()
            case "email"                : return RuleEmail()
            case "containsSpecialChars" : return RuleContainSpecialChars()
            case "containsNumber"       : return RuleContainsNumber()
            case "numeric"              : return RuleNumeric()
            case "length"               : return RuleLenght(Int(params.last ?? "3") ?? 3)
            case "age"                  : return RuleAge(Int(params.last ?? "18") ?? 18)
            default                     : return nil
            }
        }
    }
    
    init(_ rules:[Rule] = []){
        self.rules = rules
    }
    
    public func validate(_ field:UITextField) -> Rules {
        Rules(rules.reject {
            if (field.text == nil || field.text == "" && !($0 is RuleRequired)){
                return true
            }
            return $0.isValid(field.text ?? "")
        })
    }
    
    public var errorMessage:String {
        rules.map { $0.errorMessage }.map { NSLocalizedString($0, comment: $0) } .implode(" | ")
    }
    
    public var count:Int { rules.count }
}
