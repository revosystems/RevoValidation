import Foundation
import RevoFoundation

/**
 Spanish NIE (Número de Identidad de Extranjero) Validator
 
 Validates Spanish NIEs with the format: X/Y/Z + 7 digits + 1 control letter
 
 # Algorithm:
 - Initial letter (X, Y, Z) is converted to a number (0, 1, 2)
 - The resulting 8-digit number is validated using NIF algorithm
 
 # Example:
 - Valid: X2151135Z, Y9359951T, X9365446F
 - Invalid: X21511353Z (wrong length)
 */
public struct NIE {
    
    enum NieError: Error, CustomStringConvertible {
        case notValid
        
        var description: String {
            return "Not a valid NIF."
        }
    }
    
    public static let initialLetters = ["X", "Y", "Z"]
    
    let nie: String
    
    public init(_ nie: String) {
        self.nie = nie
    }
    
    public func validate() throws {
        let cleanNie = nie.uppercased().trimmingCharacters(in: .whitespaces)
        
        guard cleanNie.count == 9 else { throw NieError.notValid }
        
        let prefix = String(cleanNie.prefix(8))
        let nieLetter = String(prefix.prefix(1))
        
        guard Self.initialLetters.contains(nieLetter) else {
            throw NieError.notValid
        }
        
        let initialLetterAsNumber = Self.initialLetters.firstIndex(of: nieLetter)!
        let numbers = "\(initialLetterAsNumber)" + String(prefix.suffix(7))
        
        let letter = String(cleanNie.suffix(1))
        
        guard try NIF.calculateLetter(for: numbers) == letter else {
            throw NieError.notValid
        }
    }
}

