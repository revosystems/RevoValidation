import UIKit

public struct FormValidation {
    
    var fields:[Validation] = []
    
    public init(){}
    
    @discardableResult
    public mutating func addValidation(_ validation:Validation) -> Self{
        fields.append(validation)
        return self
    }
    
    @discardableResult
    public mutating func with(validations:[Validation], delegate:ValidationDelegate? = nil) -> Self {
        validations.each { addValidation($0) }
        
        if let delegate = delegate {
            setDelegate(delegate)
        }
        return self
    }
    
    @discardableResult
    public mutating func replace(validations:[Validation]) -> Self {
        fields.removeAll()
        validations.each { addValidation($0) }
        return self
    }
    
    @discardableResult
    public mutating func addValidation(for field:UITextField, rules:[Rule], errorsLabel:UILabel? = nil) -> Self{
        fields.append(
            Validation(field: field, rules: rules).displayErrorsAt(errorsLabel)
        )
        return self
    }

    public mutating func update(rules:Rules, for field:UITextField, validate:Bool = true){
        let validationField = fields.first { validation in validation.field == field}
        validationField?.update(rules: rules, validate: validate)
    }
    
    @discardableResult
    public func validate(showErrors:Bool = false) -> Bool{
        !fields.map { $0.validate(showErrors: showErrors) }
               .contains(false)
    }
    
    @discardableResult
    public func setDelegate(_ delegate:ValidationDelegate?) -> Self {
        fields.each { $0.delegate = delegate }
        return self
    }
    
    @discardableResult
    public func setupRightViewToFields(icon:String = "exclamationmark.circle" , color:UIColor = .red, size:CGFloat = 24) -> Self {
        fields.each { $0.addRightView(icon:icon, color:color) }
        return self
    }
}
