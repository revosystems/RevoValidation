import Foundation
import RevoFoundation

public class RuleNif: Rule {
    
    private let nationality: String?
    private static var fakeMode: Bool = false
    
    override var errorMessage: String {
        "Invalid NIF"
    }
    
    public init(nationality: String? = nil) {
        self.nationality = nationality
        super.init()
    }
    
    public static func fake(_ value: Bool = true) {
        fakeMode = value
    }
    
    override public func isValid(_ text: String) -> Bool {
        if Self.fakeMode {
            return true
        }
        
        let nationalityCode: String = getNationalityCode()
        
        do {
            switch nationalityCode {
            case Country.spain.rawValue:
                try RuleNifSpain().validate(text)
            case Country.portugal.rawValue:
                try RuleNifPortugal().validate(text)
            case Country.dominican_republic.rawValue:
                try RuleNifDominicanRepublic().validate(text)
            default:
                return true
            }
            return true
        } catch {
            errors.append("\(error)")
            return false
        }
    }
    
    private func getNationalityCode() -> String {
        guard let nationality: String = nationality else {
            return ""
        }
        
        let normalizedNationality: String = nationality.uppercased()
        
        if let country = Country(rawValue: normalizedNationality) {
            return country.rawValue
        }
        
        return normalizedNationality
    }
}

