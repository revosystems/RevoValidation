import UIKit

struct FormValidation {
    
    var fields:[Validation] = []
    
    mutating func addValidation(for textField:UITextField, rules:[Rule], errorsLabel:UILabel? = nil){
        fields.append(Validation(field: textField, rules: rules, errorsLabel:errorsLabel))
    }
    
    func validate(){
        fields.each { $0.validate() }
    }
}
