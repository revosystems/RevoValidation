import SwiftUI
import RevoValidation
import Combine

public class FormValidator : ObservableObject {
    
    @Published public private(set) var isValid: Bool = false
    
    public private(set) var errorMessage:String = ""
    public var fieldErrors: [String: Rules?] = [:]

    
    public init() {}
    
    public func validate() -> Bool {
        updateIsValid()
        return isValid
    }

    func setErrors(for fieldID: String, rules: Rules?) {
        fieldErrors[fieldID] = rules
        updateIsValid()
    }

    func clearField(_ fieldID: String) {
        fieldErrors.removeValue(forKey: fieldID)
        updateIsValid()
    }
    
    private func updateIsValid() {
        errorMessage = fieldErrors.map { key, values in
            values?.errorMessage ?? ""
        }.joined(separator: ", ")
        
        isValid = fieldErrors.map { key, value in
            value?.count ?? 0
        }.sum() == 0
    }
    
}

