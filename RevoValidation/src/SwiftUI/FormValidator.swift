import SwiftUI
import RevoValidation
import Combine

public class FormValidator : ObservableObject {
    
    @Published public private(set) var isValid: Bool = false
    
    public private(set) var errorMessage:String = ""
    
    public var fieldErrors: [UUID: Rules?] = [:]

    public init() {}

    func setErrors(for fieldID: UUID, rules: Rules?) {
        fieldErrors[fieldID] = rules
        updateIsValid()
    }

    func clearField(_ fieldID: UUID) {
        fieldErrors.removeValue(forKey: fieldID)
        updateIsValid()
    }
    
    private func updateIsValid(){
        errorMessage = fieldErrors.map { key, values in
            values?.errorMessage ?? ""
        }.joined(separator: ", ")
        
        isValid = fieldErrors.map { key, value in
            value?.count ?? 0
        }.sum() == 0
    }
}

