import UIKit
import RevoFoundation

public struct Rules : ExpressibleByStringLiteral {
    let rules:[Rule]
    
    @Inject
    var translator:ValidationTranslator?
    
    public init(stringLiteral value: String) {
        self.rules = value.explode("|").compactMap {
            if !$0.contains("+") { return Rules.makeRule($0) }
            return RuleCombined($0.explode("+").compactMap { return Rules.makeRule($0) }, $0)
        }
    }
    
    static func makeRule(_ rule:String) -> Rule? {
        let params = rule.explode(":")
        switch params.first! {
        case "required"             : return RuleRequired()
        case "email"                : return RuleEmail()
        case "containsSpecialChars" : return RuleContainSpecialChars()
        case "containsNumber"       : return RuleContainsNumber()
        case "numeric"              : return RuleNumeric()
        case "length"               : return RuleLenght(Int(params.last ?? "3") ?? 3)
        case "age"                  : return RuleAge(Int(params.last ?? "18") ?? 18)
        case "regexp"               : return RuleRegexp(params.last ?? "")
        case "dni"                  : return RuleDni()
        case "unique"               : return RuleUnique(existing: params.last?.explode(",") ?? [])
        case "url"                  : return RuleUrl()
        default                     : return nil
        }
    }
    
    public init(_ rules:[Rule] = []){
        self.rules = rules
    }
    
    public func validate(_ field:UITextField) -> Rules {
        Rules(rules.reject {
            if skipsValidation(field: field, rule:$0) {
                return true
            }
            return $0.isValid(field.text ?? "")
        })
    }
    
    private func skipsValidation(field:UITextField, rule:Rule) -> Bool {
        if (fieldsToCheckEvenWhenEmpty.contains {
            type(of: rule) == $0 }
        ) {
            return false
        }
        
        return field.text == nil || field.text == ""
    }
    
    var fieldsToCheckEvenWhenEmpty: [Rule.Type] {
        [
            RuleRequired.self,
            RuleRequiredIf.self
        ]
    }
    
    public var errorMessage:String {
        rules.map { $0.errorMessage }.map { translate(error:$0) } .implode(" | ")
    }
    
    public func translate(error:String) -> String {
        translator?.translate(key:error) ?? NSLocalizedString(error, comment: error)
    }
    
    public var firstErrorMessage:String {
        guard let rule = rules.first else { return "" }
        return rule.errorMessage
    }
    
    public var count:Int { rules.count }
}
