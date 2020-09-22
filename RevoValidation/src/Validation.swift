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
    
    var errorsLabelColor:UIColor?
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
    
    public func withOkText(_ text:String, _ color:UIColor? = nil) -> Validation{
        okText = text
        (color != nil) ? okTextColor = color : nil
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
            field.rightViewMode = failed.count == 0 ? .never : .always
            errorsLabel?.text = failed.errorMessage
            initDefaultErrorsColor()
            errorsLabel?.textColor = errorsLabelColor
            if failed.count == 0 {
                errorsLabel?.text = okText
                (okTextColor != nil) ? errorsLabel?.textColor = okTextColor : nil
            }
        }
        return failed.count == 0
    }
    
    func initDefaultErrorsColor() {
        if errorsLabelColor == nil { errorsLabelColor = errorsLabel?.textColor }
    }
    
    func addLiveValidation(){
        field.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
    }
    
}
