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
    
    public func validate() -> Bool{
        !fields.map { $0.validate(showErrors:false) }
               .contains(false)
    }
    
    public func setDelegate(_ delegate:ValidationDelegate){
        fields.each { $0.delegate = delegate }
    }
}
