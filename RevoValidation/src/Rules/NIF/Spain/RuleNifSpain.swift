import Foundation
import RevoFoundation

public class RuleNifSpain: Rule {
    
    enum SpainNifError: Error, CustomStringConvertible {
        case notValid
        case defaultNifNotAllowed
        
        var description: String {
            switch self {
            case .notValid:
                "Not a valid NIF."
            case .defaultNifNotAllowed:
                "Default NIF not allowed"
            }
        }
    }
    
    // Default NIF that should not be accepted (commonly used as placeholder)
    static let defaultNif = "00000000T"
    
    override var errorMessage: String {
        "Invalid Spanish NIF/NIE/CIF"
    }
    
    override public func isValid(_ text: String) -> Bool {
        do {
            try validate(text)
            return true
        } catch {
            errors.append("\(error)")
            return false
        }
    }
    
    public func validate(_ value: String) throws {
        let cleanValue = value.uppercased().trimmingCharacters(in: .whitespaces)
        
        // Check if it's the default NIF
        if cleanValue == Self.defaultNif {
            throw SpainNifError.defaultNifNotAllowed
        }
        
        // Match the validation based on the format
        switch true {
        case cleanValue.startsWith(CIF.initialLetters):
            try CIF(cleanValue).validate()
        case cleanValue.startsWith(NIE.initialLetters):
            try NIE(cleanValue).validate()
        default:
            try NIF(cleanValue).validate()
        }
    }
}

