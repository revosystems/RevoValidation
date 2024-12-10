
import XCTest
@testable import RevoValidation

class RuleRegexpTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_it_validates_a_regexp(){
        
        let rule = RuleRegexp("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        XCTAssertTrue(rule.isValid("patata@revo.works"))
        
        XCTAssertFalse(rule.isValid("patata-revo.works"))
        
    }
    
    func test_it_can_validate_a_gift_card(){
        let rule = RuleRegexp("[a-zA-Z0-9-]{1,50}")
        XCTAssertTrue(rule.isValid("1234-1234"))
        XCTAssertTrue(rule.isValid("abCD-1234-ABCD"))
        
        XCTAssertFalse(rule.isValid("ÀBC"))
        XCTAssertFalse(rule.isValid("ABC_DEF"))
    }
}
