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

