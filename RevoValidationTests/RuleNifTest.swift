
import XCTest
@testable import RevoValidation

class RuleNifTest: XCTestCase {

    override func setUpWithError() throws {
        RuleNif.fake(false) // Ensure fake mode is off for tests
    }

    override func tearDownWithError() throws {
        RuleNif.fake(false) // Reset fake mode
    }
    
    // MARK: - General NIF Rule Tests (by Country)
    
    func test_validates_any_nif_for_countries_without_specific_validation() {
        let countriesWithoutValidation = ["FR", "IT", "DE", "US", "GB", "CN", "JP", "IN", "BR", "RU"]
        
        for country in countriesWithoutValidation {
            let rule = RuleNif(nationality: country)
            
            // Any NIF should be valid for countries without specific validation
            XCTAssertTrue(rule.isValid("ANY-NIF-1234"), "Failed for country: \(country)")
            XCTAssertTrue(rule.isValid("65427542"), "Failed for country: \(country)")
            XCTAssertTrue(rule.isValid("-"), "Failed for country: \(country)")
        }
    }
    
    func test_validates_spanish_nifs_on_spanish_data() {
        let rule = RuleNif(nationality: "ES")
        
        // Invalid NIF format
        XCTAssertFalse(rule.isValid("ANY-NIF-1234"))
        
        // Valid Spanish NIF
        XCTAssertTrue(rule.isValid("12151135M"))
        
        // Invalid - looks like Portuguese NIF
        XCTAssertFalse(rule.isValid("360529097"))
    }
    
    func test_validates_portuguese_nifs_on_portuguese_data() {
        let rule = RuleNif(nationality: "PT")
        
        // Invalid NIF format
        XCTAssertFalse(rule.isValid("ANY-NIF-1234"))
        
        // Invalid - Spanish NIF format
        XCTAssertFalse(rule.isValid("12151135M"))
        
        // Valid Portuguese NIF
        XCTAssertTrue(rule.isValid("360529097"))
    }
    
    func test_validates_dominican_republic_nifs_on_dominican_data() {
        let rule = RuleNif(nationality: "DO")
        
        // Invalid NIF format
        XCTAssertFalse(rule.isValid("ANY-NIF-1234"))
        
        // Invalid - Spanish NIF format
        XCTAssertFalse(rule.isValid("12151135M"))
        
        // Invalid - Portuguese NIF format (9 digits but wrong check digit for Dominican)
        XCTAssertFalse(rule.isValid("987654321"))
        
        // Valid Dominican Cédula (11 digits)
        XCTAssertTrue(rule.isValid("00131978959"))
        
        // Valid Dominican RNC (9 digits)
        XCTAssertTrue(rule.isValid("132123921"))
    }

    // MARK: - Spain NIF Tests
    
    func test_can_calculate_dni_letter() {
        
        // Valid letter calculations
        XCTAssertEqual("M", try! NIF.calculateLetter(for: "12151135"))
        XCTAssertEqual("M", try! NIF.calculateLetter(for: "39359951"))
        XCTAssertEqual("A", try! NIF.calculateLetter(for: "39365446"))
        
        // Non-numerical should throw error
        do {
            let _ = try NIF.calculateLetter(for: "9356L651")
            XCTFail("Should have thrown an exception for non-numerical input")
        } catch {
            // Expected to throw - Non numerical error
            XCTAssertNotNil(error)
        }
    }

    func test_correct_spain_nif_passes() {
        let rule = RuleNif(nationality: "ES")
        XCTAssertTrue(rule.isValid("12151135M"))
        XCTAssertTrue(rule.isValid("39359951M"))
        XCTAssertTrue(rule.isValid("39365446A"))
    }
    
    func test_correct_spain_nif_passes_with_spain_string() {
        let rule = RuleNif(nationality: "SPAIN")
        XCTAssertTrue(rule.isValid("12151135M"))
        XCTAssertTrue(rule.isValid("39359951M"))
    }
    
    func test_incorrect_spain_nif_fails() {
        let rule = RuleNif(nationality: "ES")
        XCTAssertFalse(rule.isValid("12151135G"))
        XCTAssertFalse(rule.isValid("3935995AM"))
        XCTAssertFalse(rule.isValid("393654466A"))
    }
    
    func test_spain_nif_case_insensitive() {
        let rule = RuleNif(nationality: "ES")
        XCTAssertTrue(rule.isValid("12151135m"))
        XCTAssertTrue(rule.isValid("39359951m"))
    }
    
    func test_spain_default_nif_not_allowed() {
        let rule = RuleNif(nationality: "ES")
        // Default NIF should not be accepted
        XCTAssertFalse(rule.isValid("00000000T"))
    }
    
    func test_spain_nie_passes() {
        let rule = RuleNif(nationality: "ES")
        XCTAssertTrue(rule.isValid("X2151135Z"))
        XCTAssertTrue(rule.isValid("Y9359951T"))
        XCTAssertTrue(rule.isValid("X9365446F"))
    }
    
    func test_spain_nie_fails() {
        let rule = RuleNif(nationality: "ES")
        // Invalid NIE
        XCTAssertFalse(rule.isValid("X21511353Z"))  // Wrong length
        XCTAssertFalse(rule.isValid("Y9359951AT"))  // Wrong length
        XCTAssertFalse(rule.isValid("X9365446A"))   // Wrong letter
    }
    
    func test_spain_cif_passes() {
        let rule = RuleNif(nationality: "ES")
        XCTAssertTrue(rule.isValid("A58818501"))
        XCTAssertTrue(rule.isValid("B66353780"))    // Revo
        XCTAssertTrue(rule.isValid("B42846949"))    // Codepassion
        XCTAssertTrue(rule.isValid("Q2805800F"))    // Ayuntamiento fuenlabrada
        XCTAssertTrue(rule.isValid("Q0811200E"))    // Ayuntamiento MANRESA
        XCTAssertTrue(rule.isValid("Q2818018J"))    // Universidad Alcala
        XCTAssertTrue(rule.isValid("V09989153"))
        XCTAssertTrue(rule.isValid("J16720468"))
    }
    
    func test_spain_cif_fails() {
        let rule = RuleNif(nationality: "ES")
        XCTAssertFalse(rule.isValid("A58818502"))   // Wrong control digit
        XCTAssertFalse(rule.isValid("B663537780"))  // Wrong length
        XCTAssertFalse(rule.isValid("B428469A9"))   // Invalid format
    }
    
    func test_spain_validates_weird_ones() {
        let rule = RuleNif(nationality: "ES")
        // Special cases from PHP tests
        XCTAssertTrue(rule.isValid("N7350619H"))   // N: Entidades extranjeras
        XCTAssertTrue(rule.isValid("S3931107A"))   // S: Organos de la Administración del Estado y Comunidades Autónomas
        XCTAssertTrue(rule.isValid("W8243155B"))   // W: Establecimientos permanentes de entidades no residentes en España
    }
    
    // MARK: - Portugal NIF Tests
    
    func test_correct_portugal_nif_passes() {
        let rule = RuleNif(nationality: "PT")
        // Valid Portuguese NIFs from PHP tests
        let validNifs = [
            "360529097",
            "331106817",
            "170952479",
            "556572084"
        ]
        
        for nif in validNifs {
            XCTAssertTrue(rule.isValid(nif), "NIF should be valid: \(nif)")
        }
    }
    
    func test_incorrect_portugal_nif_fails() {
        let rule = RuleNif(nationality: "PT")
        // Invalid Portuguese NIFs from PHP tests
        let invalidNifs = [
            "987654321",    // Invalid check digit
            "999999999",    // Invalid check digit
            "12345678",     // Too short
            "1234567890",   // Too long
            "A23456789",    // Not numeric
            "1234B6789",    // Not numeric
            "12345678C",    // Not numeric
            "023456789",    // Starts with 0
            "423456789",    // Starts with 4
        ]
        
        for nif in invalidNifs {
            XCTAssertFalse(rule.isValid(nif), "NIF should be invalid: \(nif)")
        }
    }
    
    func test_portugal_nif_valid_first_digits() {
        let rule = RuleNif(nationality: "PT")
        // Valid first digits: 1, 2, 3, 5, 6, 7, 8, 9 (with correct check digits)
        XCTAssertTrue(rule.isValid("111111110"))  // Starts with 1
        XCTAssertTrue(rule.isValid("211111112"))  // Starts with 2
        XCTAssertTrue(rule.isValid("311111114"))  // Starts with 3
        XCTAssertTrue(rule.isValid("511111118"))  // Starts with 5
        XCTAssertTrue(rule.isValid("611111110"))  // Starts with 6
        XCTAssertTrue(rule.isValid("711111111"))  // Starts with 7
        XCTAssertTrue(rule.isValid("811111113"))  // Starts with 8
        XCTAssertTrue(rule.isValid("911111115"))  // Starts with 9
    }
    
    // MARK: - Dominican Republic NIF Tests
    
    func test_correct_dominican_cedula_passes() {
        let rule = RuleNif(nationality: "DO")
        // Valid Dominican Cédulas (11 digits)
        let validCedulas = [
            "00131978959",
            "02800570638",
            "00131785222",
            "40235300353"
        ]
        
        for cedula in validCedulas {
            XCTAssertTrue(rule.isValid(cedula), "Cédula should be valid: \(cedula)")
        }
    }
    
    func test_incorrect_dominican_cedula_fails() {
        let rule = RuleNif(nationality: "DO")
        // Invalid Dominican Cédulas
        let invalidCedulas = [
            "00131978958",  // Wrong check digit
            "00013918253",  // Starts with 000
            "123",          // Too short
            "ABCDEFGHIJK"   // Non-numeric
        ]
        
        for cedula in invalidCedulas {
            XCTAssertFalse(rule.isValid(cedula), "Cédula should be invalid: \(cedula)")
        }
    }
    
    func test_correct_dominican_rnc_passes() {
        let rule = RuleNif(nationality: "DO")
        // Valid Dominican RNCs (9 digits)
        let validRNCs = [
            "132123921",
            "130624127",
            "101630523"
        ]
        
        for rnc in validRNCs {
            XCTAssertTrue(rule.isValid(rnc), "RNC should be valid: \(rnc)")
        }
    }
    
    func test_incorrect_dominican_rnc_fails() {
        let rule = RuleNif(nationality: "DO")
        // Invalid Dominican RNCs
        let invalidRNCs = [
            "13062412",   // Too short
            "832123921"   // Starts with invalid number
        ]
        
        for rnc in invalidRNCs {
            XCTAssertFalse(rule.isValid(rnc), "RNC should be invalid: \(rnc)")
        }
    }
    
    func test_dominican_nif_with_dashes() {
        let rule = RuleNif(nationality: "DO")
        // Cédulas and RNCs often use dashes
        XCTAssertTrue(rule.isValid("001-3197895-9"))  // Cédula with dashes
        XCTAssertTrue(rule.isValid("1-32-12392-1"))   // RNC with dashes
    }
    
    // MARK: - Fake Mode Tests
    
    func test_fake_mode_accepts_any_value() {
        RuleNif.fake(true)
        let rule = RuleNif(nationality: "ES")
        
        // Should accept invalid NIFs when in fake mode
        XCTAssertTrue(rule.isValid("invalid"))
        XCTAssertTrue(rule.isValid("123"))
        XCTAssertTrue(rule.isValid(""))
    }
    
    func test_fake_mode_can_be_disabled() {
        RuleNif.fake(true)
        let rule = RuleNif(nationality: "ES")
        XCTAssertTrue(rule.isValid("invalid"))
        
        RuleNif.fake(false)
        let rule2 = RuleNif(nationality: "ES")
        XCTAssertFalse(rule2.isValid("invalid"))
    }
    
    // MARK: - Default Behavior Tests
    
    func test_without_nationality_accepts_any_nif() {
        let rule = RuleNif()
        // Should accept any NIF when no nationality is provided
        XCTAssertTrue(rule.isValid("ANY-NIF-1234"))
        XCTAssertTrue(rule.isValid("12151135M"))
        XCTAssertTrue(rule.isValid("12151135G"))
        XCTAssertTrue(rule.isValid("360529097"))
    }
    
    func test_with_invalid_nationality_accepts_any_nif() {
        let rule = RuleNif(nationality: "INVALID")
        // Should accept any NIF when nationality is not ES or PT
        XCTAssertTrue(rule.isValid("ANY-NIF-1234"))
        XCTAssertTrue(rule.isValid("12151135M"))
        XCTAssertTrue(rule.isValid("12151135G"))
        XCTAssertTrue(rule.isValid("360529097"))
    }
    
    // MARK: - Edge Cases
    
    func test_nif_with_whitespace() {
        let ruleES = RuleNif(nationality: "ES")
        XCTAssertTrue(ruleES.isValid(" 12151135M "))
        
        let rulePT = RuleNif(nationality: "PT")
        XCTAssertTrue(rulePT.isValid(" 123456789 "))
    }
    
    // MARK: - Individual Rule Tests
    
    func test_spain_rule_directly() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("12151135M"))
        XCTAssertTrue(rule.isValid("39359951M"))
        XCTAssertFalse(rule.isValid("12151135G"))
    }
    
    func test_portugal_rule_directly() {
        let rule = RuleNifPortugal()
        XCTAssertTrue(rule.isValid("360529097"))
        XCTAssertTrue(rule.isValid("331106817"))
        XCTAssertFalse(rule.isValid("987654321"))
    }
    
    func test_dominican_republic_rule_directly() {
        let rule = RuleNifDominicanRepublic()
        // Valid Cédula
        XCTAssertTrue(rule.isValid("00131978959"))
        // Valid RNC
        XCTAssertTrue(rule.isValid("132123921"))
        // Invalid
        XCTAssertFalse(rule.isValid("00131978958"))
    }
    
    // MARK: - Spain Individual Components Tests
    
    func test_spain_nif_struct_directly() {
    
        // Valid NIFs
        XCTAssertNoThrow(try NIF("12151135M").validate())
        XCTAssertNoThrow(try NIF("39359951M").validate())
        XCTAssertNoThrow(try NIF("39365446A").validate())
        
        // Invalid NIFs
        XCTAssertThrowsError(try NIF("12151135G").validate())
        XCTAssertThrowsError(try NIF("123456789").validate())
    }
    
    func test_spain_nie_struct_directly() {
        // Valid NIEs
        XCTAssertNoThrow(try NIE("X2151135Z").validate())
        XCTAssertNoThrow(try NIE("Y9359951T").validate())
        XCTAssertNoThrow(try NIE("X9365446F").validate())
        
        // Invalid NIEs
        XCTAssertThrowsError(try NIE("X9365446A").validate())
        XCTAssertThrowsError(try NIE("A1234567B").validate())
    }
    
    func test_spain_cif_struct_directly() {
        // Valid CIFs
        XCTAssertNoThrow(try CIF("A58818501").validate())
        XCTAssertNoThrow(try CIF("B66353780").validate())
        XCTAssertNoThrow(try CIF("Q2805800F").validate())
        
        // Invalid CIFs
        XCTAssertThrowsError(try CIF("A58818502").validate())
        XCTAssertThrowsError(try CIF("12345678A").validate())
    }
}

