import Foundation

public class RuleDominicanCedula : Rule {
    
    enum CedulaError: Error, CustomStringConvertible {
        case invalidLength
        case nonNumeric
        case invalidChecksum
        case invalidPrefix
        
        var description: String {
            switch self {
            case .invalidLength: return "Cédula must be 11 digits"
            case .nonNumeric: return "Cédula must contain only numbers"
            case .invalidChecksum: return "Invalid Cédula checksum"
            case .invalidPrefix: return "Cédula cannot start with 000"
            }
        }
    }
    
    override public var errorMessage: String {
        "Invalid Dominican Cédula"
    }
    
    override public func isValid(_ text: String) -> Bool {
        do {
            try CedulaValidator(cedula: text).validate()
            return true
        } catch {
            errors.append("\(error)")
            return false
        }
    }
    
    struct CedulaValidator {
        let cedula: String
        
        func validate() throws {
            let clean = cedula.replacingOccurrences(of: "-", with: "")
            
            guard clean.count == 11 else { throw CedulaError.invalidLength }
            guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: clean)) else {
                throw CedulaError.nonNumeric
            }
            
            let base = String(clean.prefix(10))
            guard !base.hasPrefix("000") else { throw CedulaError.invalidPrefix }
            
            let verifier = Int(String(clean.suffix(1)))!
            var sum = 0
            
            for (i, char) in base.enumerated() {
                guard let digit = Int(String(char)) else { throw CedulaError.nonNumeric }
                let multiplier = (i % 2 == 0) ? 1 : 2
                var result = digit * multiplier
                if result > 9 {
                    let str = String(result)
                    result = Int(String(str.prefix(1)))! + Int(String(str.suffix(1)))!
                }
                sum += result
            }
            
            let checkDigit = (10 - (sum % 10)) % 10
            guard checkDigit == verifier else { throw CedulaError.invalidChecksum }
        }
    }
}
