import XCTest
@testable import RevoValidation

class DominicanRepublicNifRuleTest: XCTestCase {
    
    typealias DominicanRule = RevoValidation.RuleNifDominicanRepublic
    
    // MARK: - Valid Cédula Tests (11 digits)
    func test_all_valid_cedulas_pass() {
        let rule = DominicanRule()
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
    
    // MARK: - Invalid Cédula Tests
    func test_all_invalid_cedulas_fail() {
        let rule = DominicanRule()
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
    
    // MARK: - Valid RNC Tests (9 digits)
    
    func test_all_valid_rncs_pass() {
        let rule = DominicanRule()
        let validRNCs = [
            "132123921",
            "130624127",
            "101630523"
        ]
        
        for rnc in validRNCs {
            XCTAssertTrue(rule.isValid(rnc), "RNC should be valid: \(rnc)")
        }
    }
    
    // MARK: - Invalid RNC Tests
    
    func test_all_invalid_rncs_fail() {
        let rule = DominicanRule()
        let invalidRNCs = [
            "13062412",   // Too short
            "832123921"   // Starts with invalid number
        ]
        
        for rnc in invalidRNCs {
            XCTAssertFalse(rule.isValid(rnc), "RNC should be invalid: \(rnc)")
        }
    }
    
    // MARK: - Format Tests
    
    func test_cedula_with_dashes() {
        let rule = DominicanRule()
        // Cédulas often use format XXX-XXXXXXX-X
        XCTAssertTrue(rule.isValid("001-3197895-9"))
        XCTAssertTrue(rule.isValid("028-0057063-8"))
    }
    
    func test_rnc_with_dashes() {
        let rule = DominicanRule()
        // RNCs often use format X-XX-XXXXX-X
        XCTAssertTrue(rule.isValid("1-32-12392-1"))
        XCTAssertTrue(rule.isValid("1-30-62412-7"))
    }
    
    func test_with_whitespace() {
        let rule = DominicanRule()
        XCTAssertTrue(rule.isValid(" 00131978959 "))
        XCTAssertTrue(rule.isValid(" 132123921 "))
    }
    
    // MARK: - Direct Validation Method Tests
    
    func test_validate_method_throws_for_invalid_cedula() {
        let rule = DominicanRule()
        
        XCTAssertThrowsError(try rule.validate("00131978958")) { error in
            XCTAssertNotNil(error)
        }
    }
    
    func test_validate_method_does_not_throw_for_valid_cedula() {
        let rule = DominicanRule()
        
        XCTAssertNoThrow(try rule.validate("00131978959"))
    }
    
    func test_validate_method_throws_for_invalid_rnc() {
        let rule = DominicanRule()
        
        XCTAssertThrowsError(try rule.validate("832123921")) { error in
            XCTAssertNotNil(error)
        }
    }
    
    func test_validate_method_does_not_throw_for_valid_rnc() {
        let rule = DominicanRule()
        
        XCTAssertNoThrow(try rule.validate("132123921"))
    }
}

