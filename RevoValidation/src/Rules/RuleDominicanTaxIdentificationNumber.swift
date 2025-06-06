import Foundation

public class RuleDominicanTaxIdentificationNumber: Rule {

    enum IdentifierError: Error, CustomStringConvertible {
        case invalidLength
        case nonNumeric
        case invalidChecksum
        case invalidCedulaPrefix
        case invalidRNCPrefix

        var description: String {
            switch self {
            case .invalidLength: return "Identifier must be 9 or 11 digits"
            case .nonNumeric: return "Identifier must contain only numbers"
            case .invalidChecksum: return "Invalid checksum for Cédula"
            case .invalidCedulaPrefix: return "Cédula cannot start with 000"
            case .invalidRNCPrefix: return "RNC must start with a valid digit (1,2,3,4,5)"
            }
        }
    }

    override public var errorMessage: String {
        "Invalid Dominican Cédula or RNC"
    }

    override public func isValid(_ text: String) -> Bool {
        do {
            try Validator(identifier: text).validate()
            return true
        } catch {
            errors.append("\(error)")
            return false
        }
    }

    struct Validator {
        let identifier: String

        func validate() throws {
            let clean = identifier.replacingOccurrences(of: "-", with: "")
            
            guard [9, 11].contains(clean.count) else {
                throw IdentifierError.invalidLength
            }
            
            guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: clean)) else {
                throw IdentifierError.nonNumeric
            }

            if clean.count == 11 {
                try validateCedula(clean)
            } else if clean.count == 9 {
                try validateRNC(clean)
            }
        }

        private func validateCedula(_ cedula: String) throws {
            guard !cedula.hasPrefix("000") else {
                throw IdentifierError.invalidCedulaPrefix
            }

            let base = String(cedula.prefix(10))
            guard let verifier = Int(String(cedula.suffix(1))) else {
                throw IdentifierError.nonNumeric
            }

            let multipliers = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2]
            var sum = 0

            for (i, char) in base.enumerated() {
                guard let digit = Int(String(char)) else {
                    throw IdentifierError.nonNumeric
                }
                var result = digit * multipliers[i]
                if result >= 10 {
                    result = (result / 10) + (result % 10)
                }
                sum += result
            }

            let remainder = sum % 10
            let checkDigit = remainder == 0 ? 0 : 10 - remainder

            guard checkDigit == verifier else {
                throw IdentifierError.invalidChecksum
            }
        }

        private func validateRNC(_ rnc: String) throws {
            let weights = [7, 9, 8, 6, 5, 4, 3, 2]
            var sum = 0

            for (i, char) in rnc.prefix(8).enumerated() {
                guard let digit = Int(String(char)) else {
                    throw IdentifierError.nonNumeric
                }
                sum += digit * weights[i]
            }

            let remainder = sum % 11
            let checkDigit: Int
            if remainder == 0 {
                checkDigit = 2
            } else if remainder == 1 {
                checkDigit = 1
            } else {
                checkDigit = 11 - remainder
            }

            guard let verifier = Int(String(rnc.suffix(1))) else {
                throw IdentifierError.nonNumeric
            }

            guard checkDigit == verifier else {
                throw IdentifierError.invalidChecksum
            }
        }
    }
}
