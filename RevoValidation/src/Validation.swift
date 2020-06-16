import UIKit
import RevoFoundation

public protocol ValidationDelegate {
    func onFieldValidated(_ validation:Validation)
}

public struct Rules : ExpressibleByStringLiteral {
    let rules:[Rule]
    
    public init(stringLiteral value: String) {
        self.rules = value.components(separatedBy: "|").compactMap { (rule:String) in
            switch rule.lowercased() {
            case "required"             : return RuleRequired()
            case "email"                : return RuleEmail()
            case "containsSpecialChar"  : return RuleContainSpecialChars()
            case "containsNumber"       : return RuleContainsNumber()
            default                     : return nil
            }
        }
    }
    
    init(_ rules:[Rule] = []){
        self.rules = rules
    }
    
    public func validate(_ field:UITextField) -> Rules {
        Rules(rules.reject {
            $0.isValid(field.text ?? "")
        })
    }
    
    public var errorMessage:String {
        rules.map { $0.errorMessage }.implode(" | ")
    }
    
    public var count:Int { rules.count }
}

public class Validation {
 
    let field:UITextField
    var errorsLabel:UILabel?
    
    let rules:Rules
    var failed:Rules = Rules()
    var okText = ""
    var delegate:ValidationDelegate?
    
    public init(field:UITextField, rules:Rules){
        self.field = field
        self.rules = rules
        addLiveValidation()
    }
    
    convenience public init(field:UITextField, rules:[Rule]){
        self.init(field:field, rules: Rules(rules))        
    }
    
    public func displayErrorsAt(_ label:UILabel?) -> Validation {
        errorsLabel = label
        errorsLabel?.text = ""
        return self
    }
    
    public func withOkText(_ text:String) -> Validation{
        okText = text
        return self
    }
    
    @objc func inputChanged(){
        validate()
        delegate?.onFieldValidated(self)
    }
    
    @discardableResult
    public func validate(showErrors:Bool = true) -> Bool {
        failed = rules.validate(field)
        if showErrors {
            errorsLabel?.text = failed.errorMessage
            if failed.count == 0 { errorsLabel?.text = okText }
        }
        return failed.count == 0
    }
    
    func addLiveValidation(){
        field.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
    }
    
}
