import UIKit

public struct FormValidation {
    
    var fields:[Validation] = []
    
    public init(){}
    
    public mutating func addValidation(_ validation:Validation){
        fields.append(validation)
    }
    
    public mutating func addValidation(for field:UITextField, rules:[Rule], errorsLabel:UILabel? = nil){
        fields.append(
            Validation(field: field, rules: rules).displayErrorsAt(errorsLabel)
        )
    }

    public mutating func modifyRulesAndValidate(for field:UITextField, rules:Rules){
        let validationField = fields.first { validation in validation.field == field}
        validationField?.update(rules: rules)
    }
    
    public func validate(showErrors:Bool = false) -> Bool{
        !fields.map { $0.validate(showErrors: showErrors) }
               .contains(false)
    }
    
    public func setDelegate(_ delegate:ValidationDelegate){
        fields.each { $0.delegate = delegate }
    }
}
