import XCTest
@testable import RevoValidation

class PortugalNifRuleTest: XCTestCase {
    
    
    // MARK: - Valid NIF Tests
    func test_all_valid_nifs_pass() {
        let rule = RuleNifPortugal()
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
    
    // MARK: - Invalid NIF Tests
    func test_all_invalid_nifs_fail() {
        let rule = RuleNifPortugal()
        let invalidNifs = [
            "987654321",
            "999999999",
            "12345678",
            "1234567890",
            "A23456789",
            "1234B6789",
            "12345678C",
            "023456789",
            "423456789"
        ]
        
        for nif in invalidNifs {
            XCTAssertFalse(rule.isValid(nif), "NIF should be invalid: \(nif)")
        }
    }
    
    // MARK: - Direct Validation Method Tests
    
    func test_validate_method_throws_for_invalid_nif() {
        let rule = RuleNifPortugal()
        
        XCTAssertThrowsError(try rule.validate("987654321")) { error in
            // Verify that it throws an error (the message might vary)
            XCTAssertNotNil(error)
        }
    }
    
    func test_validate_method_does_not_throw_for_valid_nif() {
        let rule = RuleNifPortugal()
        
        XCTAssertNoThrow(try rule.validate("360529097"))
    }
}

