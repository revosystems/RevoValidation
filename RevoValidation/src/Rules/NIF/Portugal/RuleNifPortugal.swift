import Foundation
import RevoFoundation

public class RuleNifPortugal: Rule {
    
    enum PortugalNifError: Error, CustomStringConvertible {
        case notValid
        
        var description: String {
            return "Not a valid NIF."
        }
    }
    
    static let validFirstDigits = [1, 2, 3, 5, 6, 7, 8, 9]
    
    override var errorMessage: String {
        "Invalid Portuguese NIF"
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
    
    public func validate(_ nif: String) throws {
        let cleanNif: String = nif.trimmingCharacters(in: .whitespaces)
        
        guard cleanNif.count == 9,
              cleanNif.allSatisfy({ $0.isNumber }) else {
            throw PortugalNifError.notValid
        }
        
        let digits: [Int] = cleanNif.compactMap { Int(String($0)) }
        guard digits.count == 9 else { throw PortugalNifError.notValid }
        
        guard Self.validFirstDigits.contains(digits[0]) else {
            throw PortugalNifError.notValid
        }
        
        var checkDigit: Int = 0
        for i: Int in 0..<8 {
            checkDigit += digits[i] * (10 - i - 1)
        }
        checkDigit = 11 - (checkDigit % 11)
        checkDigit = checkDigit >= 10 ? 0 : checkDigit
        
        guard checkDigit == digits[8] else {
            throw PortugalNifError.notValid
        }
    }
}

