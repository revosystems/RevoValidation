import Foundation
import RevoFoundation

/**
 Spanish NIF (Número de Identificación Fiscal) Validator
 
 Validates Spanish NIFs with the format: 8 digits + 1 control letter
 
 # Algorithm:
 The control letter is calculated from the 8-digit number modulo 23,
 then mapped to a specific letter from a predefined table.
 
 # Example:
 - Valid: 12151135M, 39359951M, 39365446A
 - Invalid: 12151135G (wrong letter)
 */
public struct NIF {
    
    enum NifError: Error, CustomStringConvertible {
        case notValid
        
        var description: String {
            return "Not a valid NIF."
        }
    }
    
    static let letterMapping = [
        "T", "R", "W", "A", "G", "M", "Y", "F", "P", "D", "X", "B", "N", "J", "Z", "S", "Q", "V", "H", "L", "C", "K", "E"
    ]
    
    let nif: String
    
    public init(_ nif: String) {
        self.nif = nif
    }
    
    public func validate() throws {
        let cleanNif = nif.uppercased().trimmingCharacters(in: .whitespaces)
        
        guard cleanNif.count == 9 else { throw NifError.notValid }
        
        let prefix = String(cleanNif.prefix(8))
        let letter = String(cleanNif.suffix(1))
        
        guard try Self.calculateLetter(for: prefix) == letter else {
            throw NifError.notValid
        }
    }
    
    public static func calculateLetter(for nifWithoutLetter: String) throws -> String {
        guard let int = Int(nifWithoutLetter) else { throw NifError.notValid }
        return letterMapping[int % 23]
    }
}

