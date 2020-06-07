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
    
    public func validate(){
        fields.each { $0.validate() }
    }
}
