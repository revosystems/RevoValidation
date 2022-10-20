import UIKit
import RevoFoundation

public protocol ValidationDelegate {
    func onFieldValidated(_ validation:Validation)
}

public class Validation {
 
    public let field:UITextField
    var errorsLabel:UILabel?
    
    var rules:Rules
    var failed:Rules = Rules()
    var okText = ""
    var delegate:ValidationDelegate?
    
    var shouldShowFirstOne:Bool = false
    
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
    
    public func shouldShowFirstOne(_ shouldShowFirstOne:Bool = true) -> Validation {
        self.shouldShowFirstOne = shouldShowFirstOne
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
        errorsLabel?.text = (shouldShowFirstOne ? failed.firstErrorMessage : failed.errorMessage)
        if okTextColor != nil { showDefaultColor() }
//        showDefaultColor()
        if failed.count == 0 {
            errorsLabel?.text = okText
            if okTextColor != nil { errorsLabel?.textColor = okTextColor }
        }
    }
    
    func addRightView(icon:String = "exclamationmark.circle" , color:UIColor = .red, size:CGFloat = 24){
        let container   = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        let iconView    = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconView.image  = UIImage(systemName: icon)
        iconView.contentMode = .center
        iconView.tintColor   = color
        container.addSubview(iconView)
        
        field.rightView            = container
    }
    
    func showDefaultColor() {
        if defaultColor == nil { defaultColor = errorsLabel?.textColor }
//        print("enter showdefaultcolor")
        errorsLabel?.textColor = defaultColor
    }
    
    func addLiveValidation(){
        field.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
    }

    public func update(rules:Rules, validate:Bool = true){
        self.rules = rules
        if (validate) {
            self.validate()
        }
    }
    
}
