import XCTest
@testable import RevoValidation

class SpainNifRuleTest: XCTestCase {
    
    // MARK: - Calculate Letter Tests
    
    func test_can_calculate_dni_letter() {
        XCTAssertEqual("M", try! NIF.calculateLetter(for: "12151135"))
        XCTAssertEqual("M", try! NIF.calculateLetter(for: "39359951"))
        XCTAssertEqual("A", try! NIF.calculateLetter(for: "39365446"))
    }
    
    func test_calculate_letter_throws_for_non_numeric() {
        XCTAssertThrowsError(try NIF.calculateLetter(for: "9356L651")) { error in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Valid NIF Tests
    
    func test_correct_nif_passes_12151135M() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("12151135M"))
    }
    
    func test_correct_nif_passes_39359951M() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("39359951M"))
    }
    
    func test_correct_nif_passes_39365446A() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("39365446A"))
    }
    
    func test_all_correct_nifs_pass() {
        let rule = RuleNifSpain()
        let correctNifs = [
            "12151135M",
            "39359951M",
            "39365446A"
        ]
        
        for nif in correctNifs {
            XCTAssertTrue(rule.isValid(nif), "NIF should be valid: \(nif)")
        }
    }
    
    // MARK: - Invalid NIF Tests
    
    func test_incorrect_nif_fails_12151135G() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("12151135G"))
    }
    
    func test_incorrect_nif_fails_3935995AM() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("3935995AM"))
    }
    
    func test_incorrect_nif_fails_393654466A() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("393654466A"))
    }
    
    func test_all_incorrect_nifs_fail() {
        let rule = RuleNifSpain()
        let incorrectNifs = [
            "12151135G",
            "3935995AM",
            "393654466A"
        ]
        
        for nif in incorrectNifs {
            XCTAssertFalse(rule.isValid(nif), "NIF should be invalid: \(nif)")
        }
    }
    
    // MARK: - Valid NIE Tests
    
    func test_correct_nie_passes_X2151135Z() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("X2151135Z"))
    }
    
    func test_correct_nie_passes_Y9359951T() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("Y9359951T"))
    }
    
    func test_correct_nie_passes_X9365446F() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("X9365446F"))
    }
    
    func test_all_correct_nies_pass() {
        let rule = RuleNifSpain()
        let correctNies = [
            "X2151135Z",
            "Y9359951T",
            "X9365446F"
        ]
        
        for nie in correctNies {
            XCTAssertTrue(rule.isValid(nie), "NIE should be valid: \(nie)")
        }
    }
    
    // MARK: - Invalid NIE Tests
    
    func test_incorrect_nie_fails_X21511353Z() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("X21511353Z"))
    }
    
    func test_incorrect_nie_fails_Y9359951AT() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("Y9359951AT"))
    }
    
    func test_incorrect_nie_fails_X9365446A() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("X9365446A"))
    }
    
    func test_all_incorrect_nies_fail() {
        let rule = RuleNifSpain()
        let incorrectNies = [
            "X21511353Z",
            "Y9359951AT",
            "X9365446A"
        ]
        
        for nie in incorrectNies {
            XCTAssertFalse(rule.isValid(nie), "NIE should be invalid: \(nie)")
        }
    }
    
    // MARK: - Valid CIF Tests
    
    func test_correct_cif_passes_A58818501() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("A58818501"))
    }
    
    func test_correct_cif_passes_B66353780() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("B66353780")) // Revo
    }
    
    func test_correct_cif_passes_B42846949() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("B42846949")) // Codepassion
    }
    
    func test_correct_cif_passes_Q2805800F() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("Q2805800F")) // Fuenlabrada
    }
    
    func test_correct_cif_passes_Q0811200E() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("Q0811200E")) // Manresa
    }
    
    func test_correct_cif_passes_Q2818018J() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("Q2818018J")) // Universidad
    }
    
    func test_correct_cif_passes_V09989153() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("V09989153"))
    }
    
    func test_correct_cif_passes_J16720468() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("J16720468"))
    }
    
    func test_all_correct_cifs_pass() {
        let rule = RuleNifSpain()
        let correctCifs = [
            "A58818501",
            "B66353780",
            "B42846949",
            "Q2805800F",
            "Q0811200E",
            "Q2818018J",
            "V09989153",
            "J16720468"
        ]
        
        for cif in correctCifs {
            XCTAssertTrue(rule.isValid(cif), "CIF should be valid: \(cif)")
        }
    }
    
    // MARK: - Invalid CIF Tests
    
    func test_incorrect_cif_fails_A58818502() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("A58818502"))
    }
    
    func test_incorrect_cif_fails_B663537780() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("B663537780"))
    }
    
    func test_incorrect_cif_fails_B428469A9() {
        let rule = RuleNifSpain()
        XCTAssertFalse(rule.isValid("B428469A9"))
    }
    
    func test_all_incorrect_cifs_fail() {
        let rule = RuleNifSpain()
        let incorrectCifs = [
            "A58818502",
            "B663537780",
            "B428469A9"
        ]
        
        for cif in incorrectCifs {
            XCTAssertFalse(rule.isValid(cif), "CIF should be invalid: \(cif)")
        }
    }
    
    // MARK: - Special Cases ("Weird Ones")
    
    func test_validates_weird_ones_N7350619H() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("N7350619H")) // N: Entidades extranjeras
    }
    
    func test_validates_weird_ones_S3931107A() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("S3931107A")) // S: Órganos de la Administración
    }
    
    func test_validates_weird_ones_W8243155B() {
        let rule = RuleNifSpain()
        XCTAssertTrue(rule.isValid("W8243155B")) // W: Establecimientos permanentes
    }
    
    func test_all_weird_ones_pass() {
        let rule = RuleNifSpain()
        let weirdOnes = [
            "N7350619H",
            "S3931107A",
            "W8243155B"
        ]
        
        for nif in weirdOnes {
            XCTAssertTrue(rule.isValid(nif), "Special NIF should be valid: \(nif)")
        }
    }
}

