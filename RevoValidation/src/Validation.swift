import UIKit
import RevoFoundation

public protocol ValidationDelegate {
    func onFieldValidated(_ validation:Validation)
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
