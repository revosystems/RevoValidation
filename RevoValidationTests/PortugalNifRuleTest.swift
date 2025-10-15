import XCTest
@testable import RevoValidation

class PortugalNifRuleTest: XCTestCase {
    
    
    // MARK: - Valid NIF Tests
    
    func test_correct_nif_passes_360529097() {
        let rule = RuleNifPortugal()
        XCTAssertTrue(rule.isValid("360529097"))
    }
    
    func test_correct_nif_passes_331106817() {
        let rule = RuleNifPortugal()
        XCTAssertTrue(rule.isValid("331106817"))
    }
    
    func test_correct_nif_passes_170952479() {
        let rule = RuleNifPortugal()
        XCTAssertTrue(rule.isValid("170952479"))
    }
    
    func test_correct_nif_passes_556572084() {
        let rule = RuleNifPortugal()
        XCTAssertTrue(rule.isValid("556572084"))
    }
    
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
    
    func test_incorrect_nif_fails_987654321() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("987654321"))
    }
    
    func test_incorrect_nif_fails_999999999() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("999999999"))
    }
    
    func test_incorrect_nif_fails_too_short() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("12345678"))
    }
    
    func test_incorrect_nif_fails_too_long() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("1234567890"))
    }
    
    func test_incorrect_nif_fails_not_numeric_A23456789() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("A23456789"))
    }
    
    func test_incorrect_nif_fails_not_numeric_1234B6789() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("1234B6789"))
    }
    
    func test_incorrect_nif_fails_not_numeric_12345678C() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("12345678C"))
    }
    
    func test_incorrect_nif_fails_starts_with_0() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("023456789"))
    }
    
    func test_incorrect_nif_fails_starts_with_4() {
        let rule = RuleNifPortugal()
        XCTAssertFalse(rule.isValid("423456789"))
    }
    
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

