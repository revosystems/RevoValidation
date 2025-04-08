import XCTest
@testable import RevoValidation

class RuleDominicanCedulaTest: XCTestCase {

    func test_valid_cedulas_pass() {
        XCTAssertTrue(RuleDominicanCedula().isValid("00131978959"))  // valid
        XCTAssertTrue(RuleDominicanCedula().isValid("02800570638"))  // valid
        XCTAssertTrue(RuleDominicanCedula().isValid("00131785222"))  // valid
    }
    
    func test_invalid_cedulas_fail() {
        XCTAssertFalse(RuleDominicanCedula().isValid("00131978958"))  // wrong check digit
        XCTAssertFalse(RuleDominicanCedula().isValid("00013918253"))  // starts with 000
        XCTAssertFalse(RuleDominicanCedula().isValid("123"))          // too short
        XCTAssertFalse(RuleDominicanCedula().isValid("ABCDEFGHIJK"))  // non-numeric
    }
}
