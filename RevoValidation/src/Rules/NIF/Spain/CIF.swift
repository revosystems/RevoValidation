import Foundation
import RevoFoundation

public struct CIF {
    
    enum CifError: Error, CustomStringConvertible {
        case notValid
        
        var description: String {
            return "Not a valid NIF."
        }
    }
    
    public static let initialLetters = [
        "A",    // Sociedad anonima
        "B",    // Sociedad limitada
        "C",    // Sociedad colectiva
        "D",    // Sociedad comaditaria
        "E",    // Comunidad de bienes
        "F",    // Sociedades corporativas
        "G",    // Asociaciones y otros tipos no definidos
        "H",    // Comunidades de propietarios
        "P",    // Corporaciones locales (Ayuntamientos) => Se trata como NIE
        "Q",    // Organismos autónomos
        "S",    // Organos de la adminstracion
        "K",    // OLD
        "L",    // OLD
        "M",    // OLD
        "J",
        "V",    // otros tipos no definidos
        "N",    // entidades extranjeras
        "R",    // religiosas
        "U",    // Uniones temporales de empresas
        "W",    // establecimientos permanentes de entidades no residentes en españa
    ]
    
    let cif: String
    
    public init(_ cif: String) {
        self.cif = cif
    }
    
    public func validate() throws {
        let cleanCif = cif.uppercased().trimmingCharacters(in: .whitespaces)
        
        guard cleanCif.count == 9 else { throw CifError.notValid }
        
        let body = String(String(cleanCif.prefix(8)).suffix(7))
        
        guard let number = Int(body), number > 0 else {
            throw CifError.notValid
        }
        
        let control = calculateControl(body: body)
        
        if isSpecialCase(cleanCif) {
            try validateSpecialCases(cleanCif: cleanCif, control: control)
            return
        }
        
        guard String(control % 10) == String(cleanCif.suffix(1)) else {
            throw CifError.notValid
        }
    }
    
    func calculateControl(body: String) -> Int {
        let sum = body.map { $0 }.mapWithIndex { element, index in
            let number = Int(String(element))!
            if (index + 1) % 2 == 0 { return number }
            return String(number * 2).map { Int(String($0))! }.reduce(0, +)
        }.reduce(0, +)
        
        return 10 - Int(String(String(sum).suffix(1)))!
    }
    
    func isSpecialCase(_ cleanCif: String) -> Bool {
        ["P", "Q", "R", "N", "S", "W"].contains(String(cleanCif.prefix(1)))
    }
    
    func validateSpecialCases(cleanCif: String, control: Int) throws {
        let control: Int = control + 64
        
        var string: String = String(Character(Unicode.Scalar(control)!))
        
        guard string == String(cleanCif.suffix(1)) else {
            throw CifError.notValid
        }
    }
}

