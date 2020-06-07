import UIKit
import RevoFoundation

public class Validation {
 
    let field:UITextField
    var errorsLabel:UILabel?
    
    let rules:[Rule]
    var failed:[Rule] = []
    var okText = ""
    
    public init(field:UITextField, rules:[Rule]){
        self.field = field
        self.rules = rules
        addLiveValidation()
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
    
    @discardableResult
    @objc public func validate() -> Bool {
        failed = rules.reject {
            $0.isValid(field.text ?? "")
        }
        errorsLabel?.text = failed.map { $0.errorMessage }.implode(" | ")
        if failed.count == 0 { errorsLabel?.text = okText }
        return failed.count == 0
    }
    
    var errors: [String] {
        rules.flatMap { $0.errors }
    }
    
    func addLiveValidation(){
        field.addTarget(self, action: #selector(validate), for: .editingChanged)
    }
    
}
