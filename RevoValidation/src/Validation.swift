import UIKit
import RevoFoundation

public protocol ValidationDelegate {
    func onFieldValidated(_ validation:Validation)
}

public class Validation {
 
    let field:UITextField
    var errorsLabel:UILabel?
    
    let rules:[Rule]
    var failed:[Rule] = []
    var okText = ""
    var delegate:ValidationDelegate?
    
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
    
    @objc func inputChanged(){
        validate()
        delegate?.onFieldValidated(self)
    }
    
    @discardableResult
    public func validate(showErrors:Bool = true) -> Bool {
        failed = rules.reject {
            $0.isValid(field.text ?? "")
        }
        if showErrors {
            errorsLabel?.text = failed.map { $0.errorMessage }.implode(" | ")
            if failed.count == 0 { errorsLabel?.text = okText }
        }
        return failed.count == 0
    }
    
    var errors: [String] {
        rules.flatMap { $0.errors }
    }
    
    func addLiveValidation(){
        field.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
    }
    
}
