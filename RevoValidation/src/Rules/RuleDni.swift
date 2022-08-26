import RevoFoundation

class RuleDni : Rule {
    
    enum DNIError : Error, CustomStringConvertible {
        case nonNumeric
        case nifInvalidLength
        case nifInvalidLetter
        
        case nieInvalidLength
        case nieInvalidInitialLetter
        case nieInvalidLetter
        
        case cifInvalidLength
        case cifInvalidControlDigit
        
        var description: String {
            switch self {
            case .nonNumeric : return "The format is not correct"
            case .nifInvalidLength : return "NIF must have a length of 9 characters"
            case .nieInvalidLength : return "NIE must have a length of 9 characters"
            case .nifInvalidLetter : return "The letter does not match the NIF"
            case .nieInvalidInitialLetter: return "The NIE initial letter is not X, Y or Z"
            case .nieInvalidLetter : return "The letter does not match the NIE"
            case .cifInvalidLength : return "CIF must have a length of 9 characters"
            case .cifInvalidControlDigit : return "CIF is not valid"
            }
        }
    }
    
    override var errorMessage: String {
        "Invalid NIF/NIE/CIF"        
    }
    
    override public func isValid(_ text:String) -> Bool {
        do {
            if text.startsWith(CIF.initialLetters) {
                try CIF(cif: text).validate()
                return true
            }
            if text.startsWith(NIE.initialLetters) {
                try NIE(nie: text).validate()
                return true
            }
            try NIF(nif: text).validate()
            return true
        } catch {
            errors.append("\(error)")
            return false
        }
    }

    //https://calculadorasonline.com/calcular-la-letra-del-dni-validar-un-dni/
    struct NIF {
        static let letterMapping = [
            "T", "R", "W", "A", "G", "M", "Y", "F", "P", "D", "X", "B", "N", "J", "Z", "S", "Q", "V", "H", "L", "C", "K", "E"
        ]
        
        let nif:String
        
        public func validate() throws {
            guard nif.count == 9 else { throw DNIError.nifInvalidLength }
            let prefix = String(nif.prefix(8))
            let letter = String(nif.suffix(1))
            guard try Self.calculateLetter(for: prefix) == letter else {
                throw DNIError.nifInvalidLetter
            }
        }
        
        public static func calculateLetter(for nifWithoutLetter:String) throws -> String {
            guard let int = Int(nifWithoutLetter) else { throw DNIError.nonNumeric }
            return letterMapping[int % 23]
        }
    }
    
    //http://www.nie.com.es/letra.html
    struct NIE {
        static let initialLetters = ["X", "Y", "Z"]
        let nie:String

        public func validate() throws {
            guard nie.count == 9 else { throw DNIError.nifInvalidLength }
            let prefix = String(nie.prefix(8))
            
            let nieLetter = String(prefix.prefix(1))
            
            guard Self.initialLetters.contains(nieLetter) else {
                throw DNIError.nieInvalidInitialLetter
            }
            
            let initialLetterAsNumber = Self.initialLetters.firstIndex(of: nieLetter)!
            let numbers = "\(initialLetterAsNumber)" + String(prefix.suffix(7))
            
            let letter = String(nie.suffix(1))
            
            guard try NIF.calculateLetter(for: numbers) == letter else {
                throw DNIError.nieInvalidLetter
            }
        }
            
    }
    
    //https://www.mapa.gob.es/app/materialvegetal/docs/CIF.pdf
    //https://www.programasprogramacion.com/articulos_cvalencia/1.htm
    struct CIF {
        static let initialLetters = [
            "A",    //Sociedad anonima
            "B",    //Sociedad limitada
            "C",    //Sociedad colectiva
            "D",    //Sociedad comaditaria
            "E",    //Comunidad de bienes
            "F",    //Sociedades corporativas
            "G",    //Asociaciones y otros tipos no definidos
            "H",    //Comunidades de propietarios
            "P",    //Corporacioens locales (Ayuntamientos) => Se trata como NIE
            "Q",    //Organismos autónomos
            "S",    //Organos de la adminstracion
            "K",    //OLD
            "L",    //OLD
            "M",    //OLD
            //"X",    //Extranjeros => Se trata como NIE
        ]
        
        let cif:String
        
        public func validate() throws {
            guard cif.count == 9 else { throw DNIError.cifInvalidLength }
            
            let body = String(String(cif.prefix(8)).suffix(7))
            
            guard let _ = Int(body) else {
                throw DNIError.nonNumeric
            }
            
            let control = calculateControl(body: body)
            
            if isSpecialCase() {
                try validateSpecialCases(control: control)
                return
            }
            
            guard String(control) == String(cif.suffix(1)) else {
                throw DNIError.cifInvalidControlDigit
            }
        }
        
        func calculateControl(body:String) -> Int {
            let sum = body.map { $0 }.mapWithIndex { element, index in
                let number = Int(String(element))!
                if (index+1) % 2 == 0 { return number }
                return String(number * 2).map { Int(String($0))! }.reduce(0, +)
            }.reduce(0, +)
            
            let control = 10 - Int(String(String(sum).suffix(1)))!
            return control == 10 ? 0 : control
        }
        
        func isSpecialCase() -> Bool {
            ["P", "Q"].contains(String(cif.prefix(1)))
        }
        
        func validateSpecialCases(control:Int) throws {
            let control = control + 64
            
            var string = ""
            string.append(Character(Unicode.Scalar(control)!))
            
            guard string == String(cif.suffix(1)) else {
                throw DNIError.cifInvalidControlDigit
            }
            return
        }
        
    }
}
