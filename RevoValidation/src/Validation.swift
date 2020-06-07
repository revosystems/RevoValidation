import UIKit
import RevoFoundation

class Validation {
 
    let field:UITextField
    let errorsLabel:UILabel?
    
    let rules:[Rule]
    var failed:[Rule] = []
    
    init(field:UITextField, rules:[Rule], errorsLabel:UILabel? = nil){
        self.field = field
        self.rules = rules
        self.errorsLabel = errorsLabel
        addLiveValidation()
    }
    
    @discardableResult
    @objc func validate() -> Bool {
        failed = rules.reject {
            $0.isValid(field.text ?? "")
        }
        errorsLabel?.text = failed.map { $0.errorMessage }.implode(" | ")
        return failed.count == 0
    }
    
    var errors: [String] {
        rules.flatMap { $0.errors }
    }
    
    func addLiveValidation(){
        field.addTarget(self, action: #selector(validate), for: .editingChanged)
    }
    
}
