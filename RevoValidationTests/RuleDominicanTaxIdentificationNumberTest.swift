import XCTest
@testable import RevoValidation

class RuleDominicanTaxIdentificationNumberTest: XCTestCase {

    func test_valid_cedulas_pass() {
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("00131978959"))  // valid
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("02800570638"))  // valid
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("00131785222"))  // valid
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("40235300353"))
    }

    func test_invalid_cedulas_fail() {
        XCTAssertFalse(RuleDominicanTaxIdentificationNumber().isValid("00131978958"))  // wrong check digit
        XCTAssertFalse(RuleDominicanTaxIdentificationNumber().isValid("00013918253"))  // starts with 000
        XCTAssertFalse(RuleDominicanTaxIdentificationNumber().isValid("123"))          // too short
        XCTAssertFalse(RuleDominicanTaxIdentificationNumber().isValid("ABCDEFGHIJK"))  // non-numeric
    }

    func test_valid_rncs_pass() {
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("132123921"))  // valid RNC
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("130624127"))  // valid RNC
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("130624127"))  // valid RNC
        XCTAssertTrue(RuleDominicanTaxIdentificationNumber().isValid("101630523"))  // valid RNC
    }

    func test_invalid_rncs_fail() {
        XCTAssertFalse(RuleDominicanTaxIdentificationNumber().isValid("13062412"))   // too short
        XCTAssertFalse(RuleDominicanTaxIdentificationNumber().isValid("832123921"))  // starts with invalid number
    }
}
