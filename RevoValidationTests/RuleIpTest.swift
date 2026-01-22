
import XCTest
@testable import RevoValidation

class RuleIpTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_it_validates_valid_ipv4_addresses(){
        let rule = RuleIp()
        
        // Valid IPs
        XCTAssertTrue(rule.isValid("192.168.1.1"))
        XCTAssertTrue(rule.isValid("10.0.0.1"))
        XCTAssertTrue(rule.isValid("255.255.255.255"))
        XCTAssertTrue(rule.isValid("0.0.0.0"))
        XCTAssertTrue(rule.isValid("127.0.0.1"))
        XCTAssertTrue(rule.isValid("8.8.8.8"))
        XCTAssertTrue(rule.isValid("172.16.0.1"))
    }
    
    func test_it_rejects_invalid_ipv4_addresses(){
        let rule = RuleIp()
        
        // Invalid IPs - out of range octets
        XCTAssertFalse(rule.isValid("256.1.1.1"))
        XCTAssertFalse(rule.isValid("1.256.1.1"))
        XCTAssertFalse(rule.isValid("1.1.256.1"))
        XCTAssertFalse(rule.isValid("1.1.1.256"))
        XCTAssertFalse(rule.isValid("999.999.999.999"))
        
        // Invalid IPs - wrong format
        XCTAssertFalse(rule.isValid("1.1.1"))
        XCTAssertFalse(rule.isValid("1.1.1.1.1"))
        XCTAssertFalse(rule.isValid("192.168.1"))
        XCTAssertFalse(rule.isValid("192.168.1.1.1"))
        
        // Invalid IPs - non-numeric
        XCTAssertFalse(rule.isValid("abc.def.ghi.jkl"))
        XCTAssertFalse(rule.isValid("192.168.1.abc"))
        XCTAssertFalse(rule.isValid("not an ip"))
        XCTAssertFalse(rule.isValid(""))
        
        // Invalid IPs - with spaces
        XCTAssertFalse(rule.isValid("192.168. 1.1"))
        XCTAssertFalse(rule.isValid(" 192.168.1.1"))
        XCTAssertFalse(rule.isValid("192.168.1.1 "))
    }
    
    func test_it_can_be_used_with_string_literal(){
        let rules: Rules = "ip"
        let errors = rules.validate("192.168.1.1")
        XCTAssertEqual(errors.count, 0)
        
        let errorsInvalid = rules.validate("256.1.1.1")
        XCTAssertEqual(errorsInvalid.count, 1)
    }
}
