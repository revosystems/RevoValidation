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
    
    var showFirstOneFlag:Bool = false
    
    var defaultColor:UIColor?
    var okTextColor:UIColor?
    
    public init(field:UITextField, rules:Rules){
        self.field = field
        self.rules = rules
        addLiveValidation()
    }
    
    convenience public init(field:UITextField, rules:[Rule]){
        self.init(field:field, rules: Rules(rules))
    }
    
    convenience public init(_ field:UITextField, _ rules:Rules, _ displayErrorsAt: UILabel? = nil){
        self.init(field:field, rules: rules)
        self.displayErrorsAt(displayErrorsAt)
    }
    
    @discardableResult
    public func displayErrorsAt(_ label:UILabel?) -> Validation {
        errorsLabel = label
        errorsLabel?.text = ""
        return self
    }
    
    public func withOkText(_ text:String, _ color:UIColor? = nil) -> Validation {
        okText = text
        okTextColor = color
        return self
    }
    
    public func showFirstOne() -> Validation {
        showFirstOneFlag = true
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
            showErrorslabel()
        }
        return failed.count == 0
    }
    
    func showErrorslabel(){
        field.rightViewMode = failed.count == 0 ? .never : .always
        errorsLabel?.text = (showFirstOneFlag ? failed.showFirstErrorMessage : failed.errorMessage)
        showDefaultColor()
        if failed.count == 0 {
            errorsLabel?.text = okText
            if okTextColor != nil { errorsLabel?.textColor = okTextColor }
        }
    }
    
    func showDefaultColor() {
        if defaultColor == nil { defaultColor = errorsLabel?.textColor }
        errorsLabel?.textColor = defaultColor
    }
    
    func addLiveValidation(){
        field.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
    }
    
}
