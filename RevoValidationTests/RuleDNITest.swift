
import XCTest
@testable import RevoValidation

class RuleDNITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_calculate_dni_letter(){
        XCTAssertEqual("M", try! RuleDni.NIF.calculateLetter(for:"12151135"))
        XCTAssertEqual("M", try! RuleDni.NIF.calculateLetter(for:"39359951"))
        XCTAssertEqual("A", try! RuleDni.NIF.calculateLetter(for:"39365446"))
        
        do {
            let _ = try RuleDni.NIF.calculateLetter(for:"9356L651")
            XCTFail("Should have throw an exception")
        }catch{
            XCTAssertEqual(RuleDni.DNIError.nonNumeric, error as! RuleDni.DNIError)
        }
    }

    func test_correct_nif_passes() {
        XCTAssertTrue(RuleDni().isValid("12151135M"))
        XCTAssertTrue(RuleDni().isValid("39359951M"))
        XCTAssertTrue(RuleDni().isValid("39365446A"))
    }
    
    func test_incorrect_nif_fails() {
        XCTAssertFalse(RuleDni().isValid("12151135G"))
        XCTAssertFalse(RuleDni().isValid("3935995AM"))
        XCTAssertFalse(RuleDni().isValid("393654466A"))
    }
    
    func test_correct_nie_passes() {
        XCTAssertTrue(RuleDni().isValid("X2151135Z"))
        XCTAssertTrue(RuleDni().isValid("Y9359951T"))
        XCTAssertTrue(RuleDni().isValid("X9365446F"))
    }
    
    func test_incorrect_nie_fails() {
        XCTAssertFalse(RuleDni().isValid("X21511353Z"))
        XCTAssertFalse(RuleDni().isValid("Y9359951AT"))
        XCTAssertFalse(RuleDni().isValid("X9365446A"))
    }
    
    func test_correct_cif_passes(){
        XCTAssertTrue(RuleDni().isValid("A58818501"))
        XCTAssertTrue(RuleDni().isValid("B66353780"))  //Revo
        XCTAssertTrue(RuleDni().isValid("B42846949"))  //Codepassion
        XCTAssertTrue(RuleDni().isValid("Q2805800F"))  //Ayuntamiento fuenlabrada
        XCTAssertTrue(RuleDni().isValid("Q0811200E"))  //Ayuntamiento MANRESA
        
        XCTAssertTrue(RuleDni().isValid("V09989153"))
        XCTAssertTrue(RuleDni().isValid("J16720468"))
        
    }
    
    func test_incorrect_cif_fails() {
        XCTAssertFalse(RuleDni().isValid("A58818502"))
        XCTAssertFalse(RuleDni().isValid("B663537780"))
        XCTAssertFalse(RuleDni().isValid("B428469A9"))  
    }
    
    func test_does_validate_weird_ones(){
        XCTAssertTrue(RuleDni().isValid("N7350619H"))   //N: Entidades extranjeras.
        XCTAssertTrue(RuleDni().isValid("S3931107A"))   //S: Organos de la Administración del Estado y Comunidades Autónomas
        XCTAssertTrue(RuleDni().isValid("W8243155B"))   //W: Establecimientos permanentes de entidades no residentes en España
    }

}
